require "hcl_parser"

class Terraspace::Terraform::Runner::Backend
  class Parser
    extend Memoist

    def initialize(mod)
      @mod = mod
    end

    def result
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
      expr = "#{@mod.cache_dir}/backend.tf*"
      Dir.glob(expr).first
    end
    memoize :backend_path
  end
end
