module Terraspace::Compiler::Dsl
  class Base
    include DslEvaluator

    attr_reader :structure
    def initialize(mod, src_path)
      @mod, @src_path = mod, src_path
      @structure = {}
    end
  end
end
