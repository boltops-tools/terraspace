module Terraspace::Terraform
  class Base < Terraspace::AbstractBase
    extend Memoist
    include Terraspace::Util::Sh

    def terraform(command_name, *args)
      within_message # only show once

      params = args.flatten.join(' ')
      command = "terraform #{command_name} #{params}"
      export_env_vars!
      run_hooks(command_name) do
        sh(command)
      end
    end

    def within_message
      dir = @mod.cache_build_dir
      pretty_dir = dir.gsub("#{Terraspace.root}/",'')
      puts "Within dir: #{pretty_dir}"
    end
    memoize :within_message

    def run_hooks(command_name, &block)
      builder = Hooks::Builder.new(@mod, command_name)
      builder.build # build hooks
      builder.run_hooks(&block)
    end

    def args
      [scoped_args].compact.flatten + auto_approve_arg + builder.args + builder.var_files
    end

    # Design be overridden by subclasses
    def scoped_args
      []
    end

    def export_env_vars!
      builder.env_vars.each do |k,v|
        ENV[k] = v
      end
    end

    def builder
      Args::Builder.new(@mod, name)
    end
    memoize :builder

    def name
      self.class.name.split("::").last.underscore # Init => init
    end

    # Some commands have -auto-approve option. IE: apply and destroy
    def auto_approve_arg
      return [] unless auto_approve_arg?
      @options[:yes] ? ["-auto-approve"] : []
    end

    def auto_approve_arg?
      false
    end
  end
end
