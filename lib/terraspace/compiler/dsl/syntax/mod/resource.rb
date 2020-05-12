module Terraspace::Compiler::Dsl::Syntax::Mod
  module Resource
    def resource(type, name, props={})
      resource = @structure[:resource] ||= {}
      resource_type = resource[type] ||= {}
      decorate!(type, props)
      resource_type[name] = props
    end

    def decorate!(type, props)
      klass = decorator_class(type)

      return unless klass
      decorator = klass.new(props)
      decorator.decorate!
    end

    def decorator_class(type)
      klass_name = type.to_s.camelize
      "Terraspace::Compiler::Dsl::Decorators::#{klass_name}".constantize rescue nil
    end
  end
end
