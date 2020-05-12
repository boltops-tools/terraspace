module Terraspace::Compiler::Dsl::Syntax::Mod
  module Terraform
    def terraform(name, props={})
      terraform = @structure[:terraform] ||= {}
      terraform[name] = props
    end
  end
end
