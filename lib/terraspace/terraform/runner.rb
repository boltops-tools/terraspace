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
      current_dir_message # only show once

      params = args.flatten.join(' ')
      command = "terraform #{name} #{params}"
      run_hooks(name) do
        sh(command, env: custom.env_vars)
      end
    end

    @@current_dir_message_shown = false
    def current_dir_message
      return if @@current_dir_message_shown
      puts "Current directory: #{Terraspace::Util.pretty_path(@mod.cache_build_dir)}"
      @@current_dir_message_shown = true
    end

    def run_hooks(name, &block)
      hooks = Hooks::Builder.new(@mod, name)
      hooks.build # build hooks
      hooks.run_hooks(&block)
    end

    def args
      # base at end in case of redirection. IE: terraform output > /path
      custom.args + custom.var_files + default.args
    end

    def custom
      Args::Custom.new(@mod, name)
    end
    memoize :custom

    def default
      Args::Default.new(@name, @options)
    end
    memoize :default
  end
end
