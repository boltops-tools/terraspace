module Terraspace::Compiler::Erb
  class Base
    include Terraspace::Compiler::Dsl::Syntax::Mod

    def initialize(mod, src_path)
      @mod, @src_path = mod, src_path
    end
  end
end
