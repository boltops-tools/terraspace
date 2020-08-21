module Terraspace
  class App
    include Singleton
    include DslEvaluator

    attr_reader :config
    def initialize
      @config = defaults
    end

    def defaults
      config = ActiveSupport::OrderedOptions.new
      config.test_framework = "rspec"
      config.logger = Logger.new($stdout)
      config.logger.level = :info
      config.hooks = Hooks.new
      config.cloud = ActiveSupport::OrderedOptions.new
      config.cloud.overwrite = true
      config.cloud.overwrite_sensitive = true
      config.cloud.relative_root = nil
      config.build = ActiveSupport::OrderedOptions.new
      config.build.cache_root = nil # defaults to /full/path/to/.terraspace-cache
      config.build.cache_dir = ":CACHE_ROOT/:REGION/:ENV/:BUILD_DIR"
      config
    end

    def configure
      yield(@config)
    end

    def load_project_config
      evaluate_file("#{Terraspace.root}/config/app.rb")
      path = "#{Terraspace.root}/config/env/#{Terraspace.env}.rb"
      evaluate_file(path)
    end
  end
end
