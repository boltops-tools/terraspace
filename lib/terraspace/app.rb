module Terraspace
  class App
    include Singleton
    include DslEvaluator

    attr_reader :config
    def initialize
      @config = ActiveSupport::OrderedOptions.new
      defaults
    end

    def defaults
      configure do |config|
        config.test_framework = "rspec"
      end
    end

    def configure
      yield(@config)
    end

    def load_project_config
      evaluate_file("#{Terraspace.root}/config/app.rb")
    end
  end
end
