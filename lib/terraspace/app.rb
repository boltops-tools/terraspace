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
      config
    end

    def configure
      yield(@config)
    end

    def load_project_config
      evaluate_file("#{Terraspace.root}/config/app.rb")
    end
  end
end
