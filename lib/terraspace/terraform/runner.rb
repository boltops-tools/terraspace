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

    # default at end in case of redirection. IE: terraform output > /path
    def args
      args = custom.args + thor.args + pass.args
      args.uniq
    end

    # From config/args/terraform.rb https://terraspace.cloud/docs/config/args/terraform/
    def custom
      Args::Custom.new(@mod, @name)
    end
    memoize :custom

    # From Thor defined/managed cli @options
    def thor
      Args::Thor.new(@mod, @name, @options)
    end
    memoize :thor

    # From Thor passthrough cli @options[:args]
    def pass
      Args::Pass.new(@mod, @name, @options)
    end
    memoize :pass

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
