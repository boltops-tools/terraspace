module Terraspace::Compiler::Strategy
  class AbstractBase
    def initialize(mod, src_path)
      @mod, @src_path = mod, src_path
    end
  end
end
