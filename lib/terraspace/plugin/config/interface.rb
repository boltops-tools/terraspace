# Should implement methods:
#    defaults
#    provider
module Terraspace::Plugin::Config
  module Interface
    include DslEvaluator

    attr_reader :config
    def initialize
      @config = defaults # provider should implement defaults
    end

    # meant to be overridden by provider
    def defaults
      ActiveSupport::OrderedOptions.new
    end

    def load_project_config
      project_config = "#{Terraspace.root}/config/plugins/#{provider}.rb"
      evaluate_file(project_config)
    end

    def configure
      yield(@config)
    end
  end
end
