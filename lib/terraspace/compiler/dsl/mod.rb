module Terraspace::Compiler::Dsl
  class Mod < Base
    include Syntax::Mod

    def build
      evaluate
      build_content
    end

    def evaluate
      evaluate_file(@src_path)
    end

    def build_content
      result = @structure.deep_stringify_keys
      JSON.pretty_generate(result)
    end
  end
end
