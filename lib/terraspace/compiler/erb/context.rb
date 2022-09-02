module Terraspace::Compiler::Erb
  class Context
    include Helpers
    include Terraspace::Compiler::HelperExtender

    attr_reader :mod, :options
    def initialize(mod)
      @mod = mod
      @options = mod.options # so user has access to cli options
      # Note: project-level config/helpers are loaded with Zeitwerk in lib/terraspace/autoloader.rb
      extend_module_level_helpers # load module-level config/helpers. IE: app/stacks/pipeline/config/helpers
    end
  end
end
