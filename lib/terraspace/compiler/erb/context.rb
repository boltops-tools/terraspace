module Terraspace::Compiler::Erb
  class Context
    include Terraspace::Compiler::Dsl::Syntax::Mod

    attr_reader :mod, :options
    def initialize(mod)
      @mod = mod
      @options = mod.options # so user has access to cli options
    end
  end
end
