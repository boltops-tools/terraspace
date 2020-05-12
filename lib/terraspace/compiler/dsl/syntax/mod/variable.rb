module Terraspace::Compiler::Dsl::Syntax::Mod
  module Variable
    def variable(name, props={})
      variable = @structure[:variable] ||= {}

      default = { type: "string" }
      props.reverse_merge!(default)

      variable[name] = props
    end
  end
end
