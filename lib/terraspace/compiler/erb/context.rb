module Terraspace::Compiler::Erb
  class Context
    include Helpers
    include Terraspace::Compiler::HelperExtender

    attr_reader :mod, :options
    def initialize(mod)
      @mod = mod
      @options = mod.options # so user has access to cli options
      extend_module_level_helpers
    end
  end
end
