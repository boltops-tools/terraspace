module Terraspace::Terraform
  class Runner < Terraspace::CLI::Base
    extend Memoist
    include Terraspace::Util

    attr_reader :name
    def initialize(name, options={})
      @name = name
      super(options)
    end

    def run
      time_took do
        terraform(name, args)
      end
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
      logger.info "Current directory: #{Terraspace::Util.pretty_path(@mod.cache_build_dir)}"
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
      Args::Default.new(@mod, @name, @options)
    end
    memoize :default

  private
    def time_took
      t1 = Time.now
      yield
      t2 = Time.now
      if %w[apply destroy].include?(@name)
        puts "Time took: #{pretty_time(t2-t1)}"
      end
    end

    # http://stackoverflow.com/questions/4175733/convert-duration-to-hoursminutesseconds-or-similar-in-rails-3-or-ruby
    def pretty_time(total_seconds)
      minutes = (total_seconds / 60) % 60
      seconds = total_seconds % 60
      if total_seconds < 60
        "#{seconds.to_i}s"
      else
        "#{minutes.to_i}m #{seconds.to_i}s"
      end
    end
  end
end
