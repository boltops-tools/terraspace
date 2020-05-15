module Terraspace::Compiler::Erb
  class Render
    include Terraspace::Compiler::Dsl::Syntax::Mod

    def initialize(mod, src_path)
      @mod, @src_path = mod, src_path
    end

    def build
      RenderMePretty.result(@src_path, context: self)
    end
  end
end
