module Terraspace::Terraform
  class Runner < Terraspace::CLI::Base
    extend Memoist
    include Terraspace::Util::Sh

    attr_reader :name
    def initialize(name, options={})
      @name = name
      @args = options[:args]
      super(options)
    end

    def run
      terraform(name, args)
    end

    def terraform(name, *args)
      within_message # only show once

      params = args.flatten.join(' ')
      command = "terraform #{name} #{params}"
      run_hooks(name) do
        sh(command, env: builder.env_vars)
      end
    end

    def within_message
      dir = @mod.cache_build_dir
      pretty_dir = dir.gsub("#{Terraspace.root}/",'')
      puts "Within dir: #{pretty_dir}"
    end
    memoize :within_message

    def run_hooks(name, &block)
      builder = Hooks::Builder.new(@mod, name)
      builder.build # build hooks
      builder.run_hooks(&block)
    end

    def args
      [@args].compact.flatten + auto_approve_arg + builder.args + builder.var_files
    end

    def builder
      Args::Builder.new(@mod, name)
    end
    memoize :builder

    # Some commands have -auto-approve option. IE: apply and destroy
    def auto_approve_arg
      return [] unless auto_approve_arg?
      @options[:yes] ? ["-auto-approve"] : []
    end

    def auto_approve_arg?
      %w[apply destroy].include?(@name)
    end
  end
end
