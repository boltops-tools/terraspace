require "hcl_parser"

module Terraspace::Compiler
  class Backend
    extend Memoist

    def initialize(mod)
      @mod = mod
    end

    def create
      klass = backend_class(backend_name)
      return unless klass # in case auto-creation is not supported for specific backend

      backend = klass.new(backend_info)
      backend.call
    end

    def backend_name
      backend_raw.keys.first # IE: s3, gcs, etc
    end

    def backend_info
      backend_raw.values.first # structure within the s3 or gcs key
    end

    def backend_raw
      return {} unless exist?(backend_path)
      if backend_path.include?('.json')
        json_backend
      else
        hcl_backend
      end
    end

    def json_backend
      data = JSON.load(IO.read(backend_path))
      data.dig("terraform", "backend") || {}
    end

    def hcl_backend
      return {} unless File.exist?(backend_path)
      backend_raw = HclParser.load(IO.read(backend_path))
      return {} unless backend_raw
      backend_raw.dig("terraform", "backend") || {}
    end

    def exist?(path)
      path && File.exist?(path)
    end

    def backend_path
      expr = "#{@mod.cache_build_dir}/backend.tf*"
      Dir.glob(expr).first
    end
    memoize :backend_path

    def backend_class(name)
      return unless name
      # IE: TerraspaceProviderAws::Interfaces::Backend
      klass_name = Terraspace::Provider.klass("Backend", backend: name)
      klass_name.constantize if klass_name
    rescue NameError
    end
  end
end
