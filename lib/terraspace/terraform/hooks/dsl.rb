module Terraspace::Terraform::Hooks
  module Dsl
    def before(*commands, **props)
      commands.each do |name|
        each_hook(:before, name, props)
      end
    end

    def after(*commands, **props)
      commands.each do |name|
        each_hook(:after, name, props)
      end
    end

    def each_hook(type, name, props={})
      @hooks[type][name] = props
    end
  end
end
