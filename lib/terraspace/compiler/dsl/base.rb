module Terraspace::Compiler::Dsl
  class Base
    include DslEvaluator

    attr_reader :structure, :options
    def initialize(mod, src_path)
      @mod, @src_path = mod, src_path
      @options = mod.options # so user has access to cli options
      @structure = {}
    end
  end
end
