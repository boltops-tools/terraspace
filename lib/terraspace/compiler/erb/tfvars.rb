module Terraspace::Compiler::Erb
  class Tfvars < Base
    def build
      RenderMePretty.result(@src_path, context: self)
    end
  end
end
