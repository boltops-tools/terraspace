module Terraspace::Compiler::Dsl::Syntax::Mod
  module Output
    def output(name, props={})
      output = @structure[:output] ||= {}
      output[name] = props
    end
  end
end
