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
      materialized_path = Dir.glob("#{@mod.cache_build_dir}/backend*").first
      return unless materialized_path && File.exist?(materialized_path)
      IO.read(materialized_path)
    end

    def fresh_backend
      src_path = Dir.glob("#{Terraspace.root}/config/backend*").first
      return unless src_path && File.exist?(src_path)
      Terraspace::Compiler::Strategy::Mod.new(@mod, src_path).run
    end
  end
end
