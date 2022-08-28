module Terraspace::Compiler::Erb
  class Render
    def initialize(mod, src_path)
      @mod, @src_path = mod, src_path
    end

    def build
      context = Context.new(@mod)
      if @mod.resolved
        RenderMePretty.result(@src_path, context: context)
      else
        # Replace contents so only the `output` and `depends_on` are evaluated
        temp_path = Rewrite.new(@src_path).rewrite
        RenderMePretty.result(temp_path, context: context)
      end
    end
  end
end
