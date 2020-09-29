module Terraspace::Compiler::Erb
  class Context
    include Helpers

    attr_reader :mod, :options
    def initialize(mod)
      @mod = mod
      @options = mod.options # so user has access to cli options
    end
  end
end
