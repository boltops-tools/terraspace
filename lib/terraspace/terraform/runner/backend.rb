class Terraspace::Terraform::Runner
  class Backend
    extend Memoist
    include Terraspace::Compiler::CommandsConcern

    def initialize(mod)
      @mod = mod
    end

    @@created = {}
    def create
      return if @@created[cache_key]
      return if Terraspace.config.auto_create_backend == false
      return unless requires_backend?

      # set immediately, since local storage wont reach bottom.
      # if fail for other backends, there will be an exception anyway
      @@created[cache_key] = true

      klass = backend_interface(backend_name)
      return unless klass # in case auto-creation is not supported for specific backend

      # IE: TerraspacePluginAws::Interfaces::Backend.new
      interface = klass.new(backend_info)
      interface.call
    end

    def cache_key
      @mod.build_dir
    end

    def backend_name
      backend.keys.first # IE: s3, gcs, etc
    end

    def backend_info
      backend.values.first # structure within the s3 or gcs key
    end

    def backend
      Parser.new(@mod).result
    end
    memoize :backend

    def backend_interface(name)
      return unless name
      # IE: TerraspacePluginAws::Interfaces::Backend
      klass_name = Terraspace::Plugin.klass("Backend", backend: name)
      klass_name.constantize if klass_name
    rescue NameError
    end

    def requires_backend?
      command_is?(requires_backend_commands)
    end

    def requires_backend_commands
      %w[down init output plan providers refresh show up validate]
    end
  end
end
