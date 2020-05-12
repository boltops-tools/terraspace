module Terraspace::Terraform
  class Base < Terraspace::AbstractBase
    extend Memoist

    def terraform(command, *args)
      dir = @mod.cache_build_dir
      pretty_dir = dir.gsub("#{Terraspace.root}/",'')
      puts "Within dir: #{pretty_dir}"

      params = args.flatten.join(' ')
      command = "terraform #{command} #{params}"
      puts "=> #{command}"

      export_env_vars!

      ENV.each do |k,v|
        if k.include?("TF_VAR_")
          puts "#{k}: #{v}"
        end
      end

      Dir.chdir(dir) do
        success = system(command)
        exit $?.exitstatus unless success
      end
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
