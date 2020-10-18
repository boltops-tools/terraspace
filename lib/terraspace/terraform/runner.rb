module Terraspace::Terraform
  class Runner < Terraspace::CLI::Base
    extend Memoist
    include Terraspace::Hooks::Concern
    include Terraspace::Util

    attr_reader :name
    def initialize(name, options={})
      @name = name
      super(options)
      @retries = 1
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
      run_hooks("terraform.rb", name) do
        Terraspace::Shell.new(@mod, command, @options.merge(env: custom.env_vars)).run
      end
    rescue Terraspace::InitRequiredError => e
      logger.info "Terraform reinitialization required detected. Will run `terraform init` and try again."
      logger.debug "Retry attempt: #{@retries}"
      logger.debug "#{e.class}"
      Runner.new("init", @options).run
      if @retries <= 3
        backoff = 2 ** @retries # 2, 4, 8
        logger.debug "Waiting #{backoff}s before retrying"
        sleep(backoff)
        @retries += 1
        retry
      else
        logger.info "ERROR: #{e.message}"
        exit 1
      end
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
