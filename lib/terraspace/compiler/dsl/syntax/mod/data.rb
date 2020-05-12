module Terraspace::Compiler::Dsl::Syntax::Mod
  module Data
    def data(type, name, props={})
      resource = @structure[:data] ||= {}
      resource_type = resource[type] ||= {}
      resource_type[name] = props
    end
  end
end
