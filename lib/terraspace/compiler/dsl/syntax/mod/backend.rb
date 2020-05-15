module Terraspace::Compiler::Dsl::Syntax::Mod
  module Backend
    def backend(name, props={})
      terraform = @structure[:terraform] ||= {}
      backend = terraform[:backend] ||= {}
      backend_expand_all!(name, props)
      backend[name] = props
    end

    def backend_expand_all!(backend_name, props={})
      Terraspace::Compiler::Expander.new(@mod, backend_name).expand(props)
    end

    def backend_expand(backend_name, string)
      Terraspace::Compiler::Expander.new(@mod, backend_name).expand_string(string)
    end
  end
end
