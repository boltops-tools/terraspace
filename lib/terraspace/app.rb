module Terraspace
  class App
    extend Memoist
    include DslEvaluator
    include Singleton
    include Terraspace::Util::Logging

    attr_reader :config
    def initialize
      @config = defaults
    end

    def defaults
      config = ActiveSupport::OrderedOptions.new
      config.all = ActiveSupport::OrderedOptions.new
      config.all.concurrency = 5
      config.all.exit_on_fail = ActiveSupport::OrderedOptions.new
      config.all.exit_on_fail.down = true
      config.all.exit_on_fail.up = true
      config.all.ignore_stacks = nil
      config.all.include_stacks = nil
      config.allow = ActiveSupport::OrderedOptions.new
      config.allow.envs = nil
      config.allow.regions = nil
      config.auto_create_backend = true
      config.build = ActiveSupport::OrderedOptions.new
      config.build.cache_dir = ":CACHE_ROOT/:REGION/:ENV/:BUILD_DIR"
      config.build.cache_root = nil # defaults to /full/path/to/.terraspace-cache
      config.build.clean_cache = nil # defaults to /full/path/to/.terraspace-cache
      config.bundle = ActiveSupport::OrderedOptions.new
      config.bundle.logger = ts_logger
      config.hooks = Hooks.new
      config.init = ActiveSupport::OrderedOptions.new
      config.init.mode = "auto" # auto, never, always
      config.log = ActiveSupport::OrderedOptions.new
      config.log.root = Terraspace.log_root
      config.logger = ts_logger
      config.logger.formatter = Logger::Formatter.new
      config.logger.level = ENV['TS_LOG_LEVEL'] || :info
      config.layering = ActiveSupport::OrderedOptions.new
      config.layering.names = {}
      config.layering.enable_names = ActiveSupport::OrderedOptions.new
      config.layering.enable_names.cache_dir = true
      config.summary = ActiveSupport::OrderedOptions.new
      config.summary.prune = false
      config.terraform = ActiveSupport::OrderedOptions.new
      config.terraform.plugin_cache = ActiveSupport::OrderedOptions.new
      config.terraform.plugin_cache.dir = ENV['TF_PLUGIN_CACHE_DIR'] || "#{Terraspace.tmp_root}/plugin_cache"
      config.terraform.plugin_cache.enabled = true
      config.terraform.plugin_cache.purge_on_error = true
      config.test_framework = "rspec"
      config.tfc = ActiveSupport::OrderedOptions.new
      config.tfc.auto_sync = true
      config.tfc.hostname = nil
      config.tfc.vars = ActiveSupport::OrderedOptions.new
      config.tfc.vars.overwrite = true
      config.tfc.vars.overwrite_sensitive = true
      config.tfc.vars.show_message = "create"
      config.tfc.working_dir_prefix = nil
      config.tfc.workspace = ActiveSupport::OrderedOptions.new
      config.tfc.workspace.attrs = ActiveSupport::OrderedOptions.new
      config
    end

    def ts_logger
      Logger.new(ENV['TS_LOG_PATH'] || $stderr)
    end
    memoize :ts_logger

    def configure
      yield(@config)
    end

    def load_project_config
      evaluate_file("#{Terraspace.root}/config/app.rb")

      # deprecated config/env for config/envs
      path = "#{Terraspace.root}/config/env/#{Terraspace.env}.rb"
      if File.exist?(path)
        # so early on in the boot process that logger.info is unavailable, use ts_logger which is available and same thing.
        ts_logger.info "DEPRECATED: Please rename config/env to config/envs. IE:".color(:yellow)
        ts_logger.info "    mv config/env config/envs"
        evaluate_file(path)
      end

      path = "#{Terraspace.root}/config/envs/#{Terraspace.env}.rb"
      evaluate_file(path)
    end
  end
end
