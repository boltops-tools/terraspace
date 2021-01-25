module Terraspace::Terraform
  class Runner < Terraspace::CLI::Base
    extend Memoist
    include Terraspace::Hooks::Concern
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
      command = "terraform #{name} #{params}".squish
      run_hooks("terraform.rb", name) do
        run_internal_hook(:before, name)
        Terraspace::Shell.new(@mod, command, @options.merge(env: custom.env_vars)).run
        run_internal_hook(:after, name)
      end
    rescue Terraspace::SharedCacheError, Terraspace::InitRequiredError
      @retryer ||= Retryer.new(@mod, @options, name, $!)
      if @retryer.retry?
        @retryer.run
        retry
      else
        exit(1)
      end
    end

    def run_internal_hook(type, name)
      begin
        klass = "Terraspace::Terraform::Ihooks::#{type.to_s.classify}::#{name.classify}".constantize
      rescue NameError
        return
      end
      ihook = klass.new(name, @options)
      ihook.run
    end

    @@current_dir_message_shown = false
    def current_dir_message
      return if @@current_dir_message_shown
      log "Current directory: #{Terraspace::Util.pretty_path(@mod.cache_dir)}"
      @@current_dir_message_shown = true
    end

    def log(msg)
      # quiet useful for RemoteState::Fetcher
      @options[:quiet] ? logger.debug(msg) : logger.info(msg)
    end

    def args
      # base at end in case of redirection. IE: terraform output > /path
      custom.args + custom.var_files + default.args
    end

    def custom
      Args::Custom.new(@mod, @name)
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
        logger.info "Time took: #{pretty_time(t2-t1)}"
      end
    end
  end
end
