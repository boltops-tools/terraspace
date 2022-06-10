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

      run_internal_hook(:after, name) # always run so plan and apply get saved to tsc
      if @shell_error
        logger.error @shell_error.message.color(:red)
        exit 1 if name == "plan" && Terraspace.command?("up")
      end
    end

    # default at end in case of redirection. IE: terraform output > /path
    def args
      args = custom.args + pass.args + thor.args
      args.uniq
    end

    # From config/args/terraform.rb https://terraspace.cloud/docs/config/args/terraform/
    def custom
      Args::Custom.new(@mod, @name)
    end
    memoize :custom

    # From Thor passthrough cli @options[:args]
    def pass
      Args::Pass.new(@mod, @name, @options)
    end
    memoize :pass

    # From Thor defined/managed cli @options
    def thor
      Args::Thor.new(@mod, @name, @options)
    end
    memoize :thor

    def terraform(name, *args)
      current_dir_message # only show once

      params = args.flatten.join(' ')
      command = "terraform #{name} #{params}".squish
      @shell_error = nil
      run_hooks("terraform.rb", name) do
        Backend.new(@mod).create
        run_internal_hook(:before, name)
        begin
          Terraspace::Shell.new(@mod, command, @options.merge(env: custom.env_vars)).run
          @success = true
        rescue Terraspace::ShellError => exception
          @shell_error = exception
          @success = false
        end
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
        class_name = "Terraspace::Terraform::Ihooks::#{type.to_s.classify}::#{name.classify}"
        klass = class_name.constantize
      rescue NameError => e
        logger.debug "DEBUG: #{e.class} #{e.message}".color(:red)
        return
      end
      ihook = klass.new(name, @options.merge(success: @success))
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
