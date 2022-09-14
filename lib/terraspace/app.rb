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
      config.all.exit_on_fail.down = false
      config.all.exit_on_fail.plan = true
      config.all.exit_on_fail.up = true

      config.allow = ActiveSupport::OrderedOptions.new
      config.allow.envs = nil
      config.allow.regions = nil
      config.allow.stacks = nil
      config.deny = ActiveSupport::OrderedOptions.new
      config.deny.envs = nil
      config.deny.regions = nil
      config.deny.stacks = nil

      config.all.exclude_stacks = nil
      config.all.include_stacks = nil
      config.all.consider_allow_deny_stacks = true

      config.auto_create_backend = true
      config.autodetect = ActiveSupport::OrderedOptions.new
      config.autodetect.expander = nil

      config.build = ActiveSupport::OrderedOptions.new
      config.build.cache_dir = ":REGION/:APP/:ROLE/:ENV/:BUILD_DIR"
      config.build.clean_cache = nil # defaults to true
      config.build.default_pass_files = ["/files/"]
      config.build.pass_files = []
      config.build.dependency_words = []

      config.bundle = ActiveSupport::OrderedOptions.new
      config.bundle.logger = ts_logger

      config.cloud = ActiveSupport::OrderedOptions.new
      config.cloud.project = Terraspace.project
      config.cloud.org = ENV['TS_ORG'] # required for Terraspace cloud
      config.cloud.record = "changes" # IE: changes or all
      config.cloud.stack = ":APP-:ROLE-:MOD_NAME-:ENV-:EXTRA-:REGION"
      config.cloud.cost = ActiveSupport::OrderedOptions.new
      config.cloud.cost.enabled = cast_boolean(ENV['TS_COST'])
      config.cloud.vcs = ActiveSupport::OrderedOptions.new
      config.cloud.vcs.name = nil # github, gitlab, bitbucket. Else default to registered terraspace_vcs_* plugin

      config.hooks = ActiveSupport::OrderedOptions.new
      config.hooks.show = true

      config.init = ActiveSupport::OrderedOptions.new
      config.init.mode = "auto" # auto, never, always

      config.log = ActiveSupport::OrderedOptions.new
      config.log.root = Terraspace.log_root
      config.logger = ts_logger
      config.logger.formatter = Logger::Formatter.new
      config.logger.level = ENV['TS_LOG_LEVEL'] || :info

      config.layering = ActiveSupport::OrderedOptions.new
      config.layering.enable_names = ActiveSupport::OrderedOptions.new
      config.layering.enable_names.expansion = true
      config.layering.names = {}
      config.layering.show = cast_boolean(ENV['TS_LAYERING_SHOW'])
      config.layering.mode = ENV['TS_LAYERING_MODE'] || "simple" # simple, namespace, provider

      config.summary = ActiveSupport::OrderedOptions.new
      config.summary.prune = false

      config.terraform = ActiveSupport::OrderedOptions.new
      config.terraform.plugin_cache = ActiveSupport::OrderedOptions.new
      config.terraform.plugin_cache.dir = ENV['TF_PLUGIN_CACHE_DIR'] || "#{Terraspace.tmp_root}/plugin_cache"
      config.terraform.plugin_cache.enabled = false
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

    # https://stackoverflow.com/questions/36228873/ruby-how-to-convert-a-string-to-boolean
    # https://github.com/rails/rails/blob/5-1-stable/activemodel/lib/active_model/type/boolean.rb
    # so dont have to add activemodel as a dependency just for this method
    FALSE_VALUES = [nil, false, 0, "0", "f", "F", "false", "FALSE", "off", "OFF"].to_set
    def cast_boolean(value)
      if value.nil? || value == ""
        nil
      else
        !FALSE_VALUES.include?(value)
      end
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
