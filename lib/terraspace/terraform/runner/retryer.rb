class Terraspace::Terraform::Runner
  class Retryer
    include Terraspace::Util::Logging
    include Terraspace::Util::Pretty

    def initialize(mod, options, command_name, exception)
      @mod, @options, @command_name, @exception = mod, options, command_name, exception
      @retries = 1
    end

    def retry?
      max_retries = ENV['TS_MAX_RETRIES'] ? ENV['TS_MAX_RETRIES'].to_i : 3
      if @retries <= max_retries && !@stop_retrying
        true # will retry
      else
        logger.info "ERROR after max retries #{max_retries}: #{@exception.message}"
        false # will not retry
      end
    end

    def run
      backoff = 2 ** @retries # 2, 4, 8
      logger.debug "Waiting #{backoff}s before retrying"
      sleep(backoff)
      @retries += 1

      case @exception
      when Terraspace::SharedCacheError
        shared_cache_error
      when Terraspace::InitRequiredError
        init_required_error
      end
    end

    def shared_cache_error
      logger.info "Terraform Shared Cache error detected. Will purge caches and run `terraform init` to try again."
      logger.debug "Retry attempt: #{@retries}"
      logger.debug "#{@exception.class}"
      logger.debug "#{@exception.message}"
      if Terraspace.config.terraform.plugin_cache.purge_on_error # Purging the cache "fixes" this terraform bug
        purge_caches
        reinit
      else
        @stop_retrying = true
      end
    end

    def init_required_error
      logger.info "Terraform reinitialization required detected. Will run `terraform init` and try again."
      logger.debug "Retry attempt: #{@retries}"
      logger.debug "#{@exception.class}"
      reinit
    end

    def reinit
      Terraspace::Terraform::Runner.new("init", @options).run unless @command_name == "init"
    end

    def purge_caches
      dir = "#{@mod.cache_dir}/.terraform"
      logger.info "Purging #{pretty_path(dir)}"
      FileUtils.rm_rf(dir)

      dir = "#{Terraspace.config.terraform.plugin_cache.dir}"
      logger.info "Purging #{pretty_path(dir)}"
      FileUtils.rm_rf(dir)
      FileUtils.mkdir_p(dir) # need /tmp/terraspace/plugin_cache dir to exist
    end
  end
end
