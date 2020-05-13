class Terraspace::Compiler::Cleaner
  class BackendChange
    def initialize(mod)
      @mod = mod
    end

    def purge
      return unless purge?
      puts "Backend change detected. Removing #{Terraspace::Util.pretty_path(Terraspace.cache_root)} for reinitialization"
      FileUtils.rm_rf(Terraspace.cache_root)
    end

    # Whenever the backend is changed, purge the cache entirely
    def purge?
      return false unless current_backend
      current_backend != fresh_backend
    end

    def current_backend
      materialized_path = find_src_path("#{@mod.cache_build_dir}/backend*")
      IO.read(materialized_path) if materialized_path
    end

    def fresh_backend
      src_path = find_src_path("#{Terraspace.root}/config/backend*")
      Terraspace::Compiler::Strategy::Mod.new(@mod, src_path).run if src_path
    end

  private
    def find_src_path(expr)
      path = Dir.glob(expr).first
      path if path && File.exist?(path)
    end
  end
end
