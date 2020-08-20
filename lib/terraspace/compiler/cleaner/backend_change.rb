class Terraspace::Compiler::Cleaner
  class BackendChange
    include Terraspace::Util

    def initialize(mod, options={})
      @mod, @options = mod, options
    end

    def purge
      return unless purge?

      cache_root = Terraspace::Util.pretty_path(Terraspace.cache_root)
      message =<<~EOL
        Backend change detected. Will remove #{cache_root} for complete reinitialization
        WARN: If you are using local storage for state, this will remove it.
        Will remove #{cache_root}
      EOL
      sure?(message.strip)
      logger.info "Backend change detected. Removing #{cache_root} for complete reinitialization"
      FileUtils.rm_rf(Terraspace.cache_root)
    end

    # Whenever the backend is changed, purge the cache entirely
    def purge?
      return false unless current_backend
      current_backend != fresh_backend
    end

    def current_backend
      materialized_path = find_src_path("#{@mod.cache_dir}/backend*")
      IO.read(materialized_path) if materialized_path
    end

    def fresh_backend
      src_path = find_src_path("#{Terraspace.root}/config/terraform/backend*")
      Terraspace::Compiler::Strategy::Mod.new(@mod, src_path).run if src_path
    end

  private
    def find_src_path(expr)
      path = Dir.glob(expr).first
      path if path && File.exist?(path)
    end
  end
end
