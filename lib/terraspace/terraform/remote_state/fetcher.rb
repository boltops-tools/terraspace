module Terraspace::Terraform::RemoteState
  class Fetcher
    extend Memoist
    include Terraspace::Compiler::CommandsConcern
    include Terraspace::Util::Logging

    def initialize(parent, identifier, options={})
      @parent, @identifier, @options = parent, identifier, options
      child_name, @output_key = identifier.split('.')
      @child = Terraspace::Mod.new(child_name)
      @child.resolved = @parent.resolved
    end

    def run
      validate! # check child stack exists
      pull
      load
    end

    # Returns OutputProxy
    def output
      run
      if pull_success?
        pull_success_output
      else
        @error_type ||= :state_not_found # could be set to :bucket_not_found by bucket_not_found_error
        error = output_error(@error_type)
        OutputProxy.new(@child, nil, @options.merge(error: error))
      end
    end

    def pull_success_output
      if @outputs.key?(@output_key)
        OutputProxy.new(@child, output_value, @options)
      else
        error = output_error(:key_not_found)
        OutputProxy.new(@child, nil, @options.merge(error: error))
      end
    end

    def output_value
      return unless @outputs.key?(@output_key)
      result = @outputs.dig(@output_key)
      result.dig("value") if result
    end

    def output_error(type)
      msg = case type
      when :key_not_found
        "Output #{@output_key} was not found for the #{@parent.name} tfvars file. Either #{@child.name} stack has not been deployed yet or it does not have this output: #{@output_key}"
      when :state_not_found
        "Output #{@output_key} could not be looked up for the #{@parent.name} tfvars file. #{@child.name} stack needs to be deployed"
      when :bucket_not_found
        "The bucket for the backend could not be found"
      end
      msg = "(#{msg})"
      log_message(msg)
      msg
    end

    @@pull_successes = {}
    @@download_shown = false
    def pull
      return if @@pull_successes[cache_key]
      logger.info "Downloading tfstate files for dependencies defined in tfvars..." unless @@download_shown || @options[:quiet]
      @@download_shown = true
      logger.debug "Downloading tfstate for stack: #{@child.name}"

      success = init # init not yet run. only run .init directly, not .run. init can completely error and early exit.
      return unless success

      FileUtils.mkdir_p(File.dirname(state_path))
      command = "cd #{@child.cache_dir} && terraform state pull > #{state_path}"
      logger.debug "=> #{command}"
      success = system(command)
      # Can error if using a old terraform version and the statefile was created with a newer version of terraform
      # IE: Failed to refresh state: state snapshot was created by Terraform v0.13.2, which is newer than current v0.12.29;
      #     upgrade to Terraform v0.13.2 or greater to work with this state
      unless success
        logger.info "Error running: #{command}".color(:red)
        logger.info "Please fix the error before continuing"
      end
      @@pull_successes[cache_key] = success
    end

    def init
      Terraspace::CLI::Init.new(mod: @child.name, quiet: true, suppress_error_color: true).init
      true
    rescue Terraspace::BucketNotFoundError # from Terraspace::Shell
      bucket_not_found_error
      false
    end

    # mimic pull error
    def bucket_not_found_error
      @@pull_successes[cache_key] = false
      @error_type = :bucket_not_found
    end

    def load
      return self unless pull_success?

      # use or set cache
      if @@cache[cache_key]
        @outputs = @@cache[cache_key]
      else
        @outputs = @@cache[cache_key] = read_statefile_outputs
      end

      self
    end
    memoize :load

    def cache_key
      @child.name
    end

    def read_statefile_outputs
      data = JSON.load(IO.read(state_path))
      data ? data['outputs'] : {}
    end

    def pull_success?
      @@pull_successes[cache_key]
    end

    def state_path
      "#{Terraspace.tmp_root}/remote_state/#{@child.build_dir}/state.json"
    end

    # Note we already validate mod exist at the terraform_output helper. This is just in case that logic changes.
    def validate!
      return if @child.exist?
      logger.error "ERROR: stack #{@child.name} not found".color(:red)
      exit 1
    end

    # Using debug level because all the tfvar files always get evaluated.
    # So dont want these messages to show up and be noisy unless debugging.
    def log_message(msg)
      logger.debug "DEBUG: #{msg}".color(:yellow)
    end

    cattr_accessor :cache, default: {}
    class << self
      def flush!
        @@pull_successes = {}
        @@cache = {}
      end
    end
  end
end
