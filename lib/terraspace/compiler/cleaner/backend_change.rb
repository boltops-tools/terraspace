class Terraspace::Compiler::Cleaner
  class BackendChange
    include Terraspace::Util

    def initialize(mod, options={})
      @mod, @options = mod, options
    end

    def purge
      return unless purge?

      are_you_sure? if local_statefile_exist?
      cache_root = Terraspace::Util.pretty_path(Terraspace.cache_root)
      logger.debug "Backend change detected. Removing #{cache_root} for complete reinitialization"
      FileUtils.rm_rf(Terraspace.cache_root)
    end

    # Whenever the backend is changed, purge the cache entirely
    def purge?
      return false unless current_backend
      current_backend != fresh_backend
    end

    def local_statefile_exist?
      # Note: Will not go into .terraform folders. No need to for terraform.tfstate
      Dir.glob("#{Terraspace.cache_root}/**/*").each do |path|
        basename = File.basename(path)
        return true if basename == 'terraform.tfstate'
      end
      false
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
    def are_you_sure?
      cache_root = Terraspace::Util.pretty_path(Terraspace.cache_root)
      message =<<~EOL
        Backend change detected. Will remove #{cache_root} for complete reinitialization
        #{"WARN: You are using local storage for state, this will remove it.".color(:yellow)}
        Will remove #{cache_root} and all terraform.tfstate files
      EOL
      sure?(message.strip) # from Util
    end

    def find_src_path(expr)
      path = Dir.glob(expr).first
      path if path && File.exist?(path)
    end
  end
end
