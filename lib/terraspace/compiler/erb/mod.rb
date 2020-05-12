module Terraspace::Compiler::Erb
  class Mod < Base
    def build
      RenderMePretty.result(@src_path, context: self)
    end
  end
end
