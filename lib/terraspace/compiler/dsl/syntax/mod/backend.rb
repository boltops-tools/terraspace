module Terraspace::Compiler::Dsl::Syntax::Mod
  module Backend
    def backend(name, props={})
      terraform = @structure[:terraform] ||= {}
      backend = terraform[:backend] ||= {}
      expansion_all!(name, props)
      backend[name] = props
    end

    def expansion_all!(backend_name, props={})
      Terraspace::Compiler::Expander.new(@mod, backend_name).expand(props)
    end

    # Can set opts to explicitly use an specific backend. Example:
    #
    #    opts = {backend: s3}
    #
    # Else Terraspace autodetects the backend installed.
    #
    def expansion(string, opts={})
      expander = Terraspace::Compiler::Expander.autodetect(@mod, opts)
      expander.expansion(string)
    end

    # DEPRECATED: Will be removed in future release
    def backend_expand(backend_name, string)
      logger.info "DEPRECATED backend_expand: instead use expansion(string)"
      Terraspace::Compiler::Expander.new(@mod, backend_name).expansion(string)
    end
  end
end
