module Terraspace::Compiler::Erb
  class Render
    def initialize(mod, src_path)
      @mod, @src_path = mod, src_path
    end

    def build
      context = Context.new(@mod)
      RenderMePretty.result(@src_path, context: context)
    end
  end
end
