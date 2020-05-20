module Terraspace::Terraform
  class Runner < Terraspace::CLI::Base
    extend Memoist
    include Terraspace::Util::Sh

    attr_reader :name
    def initialize(name, options={})
      @name = name
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
        sh(command, env: custom.env_vars)
      end
    end

    def within_message
      dir = @mod.cache_build_dir
      pretty_dir = dir.gsub("#{Terraspace.root}/",'')
      puts "Within dir: #{pretty_dir}"
    end
    memoize :within_message

    def run_hooks(name, &block)
      hooks = Hooks::Builder.new(@mod, name)
      hooks.build # build hooks
      hooks.run_hooks(&block)
    end

    def args
      # base at end in case of redirection. IE: terraform output > /path
      custom.args + custom.var_files + base.args
    end

    def custom
      Args::Custom.new(@mod, name)
    end
    memoize :custom

    def base
      Args::Base.new(@name, @options)
    end
    memoize :base
  end
end
