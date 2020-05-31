module Terraspace::Compiler::Dsl::Syntax::Mod
  module Resource
    def resource(type, name, props={})
      resource = @structure[:resource] ||= {}
      resource_type = resource[type] ||= {}
      props = decorate(type, props)
      resource_type[name] = props
    end

    def decorate(type, props)
      klass = decorator_class(type)
      return props unless klass
      decorator = klass.new(type, props)
      decorator.call
    end

    def decorator_class(type)
      # IE: TerraspacePluginAws::Interfaces::Decorator
      klass_name = Terraspace::Plugin.klass("Decorator", resource: type)
      klass_name.constantize if klass_name
    rescue NameError
    end
  end
end
