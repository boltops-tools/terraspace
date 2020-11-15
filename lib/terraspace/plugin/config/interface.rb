# Should implement methods:
#    defaults
#    provider
module Terraspace::Plugin::Config
  module Interface
    include DslEvaluator

    attr_reader :config
    def initialize
      @config = defaults # plugin should implement defaults
    end

    # meant to be overridden by plugin
    def defaults
      ActiveSupport::OrderedOptions.new
    end

    def load_project_config
      evaluate_file("#{Terraspace.root}/config/plugins/#{provider}.rb")
      evaluate_file("#{Terraspace.root}/config/plugins/#{provider}/#{Terraspace.env}.rb")
    end

    def configure
      yield(@config)
    end
  end
end
