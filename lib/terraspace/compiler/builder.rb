module Terraspace::Compiler
  class Builder
    include Basename

    def initialize(mod)
      @mod = mod
    end

    def build
      build_config
      build_module if @mod.resolved
      build_tfvars
    end

    # build common config files: provider and backend for the root module
    def build_config
      return unless build?
      build_config_terraform
    end

    def build_module
      with_mod_file do |src_path|
        build_mod_file(src_path)
      end
    end

    def build_tfvars
      return unless build?
      Strategy::Tfvar.new(@mod).run # writer within Strategy to control file ordering
    end

  private
    def build?
      @mod.type == "stack" || @mod.root_module?
    end

    def build_config_terraform
      expr = "#{Terraspace.root}/config/terraform/**/*"
      Dir.glob(expr).each do |path|
        next unless File.file?(path)
        build_config_file(basename(path))
      end
    end

    def build_config_file(file)
      existing = Dir.glob("#{@mod.root}/#{file}").first
      return if existing && existing.ends_with?(".tf") # do not overwrite existing backend.tf, provider.tf, etc

      if file.ends_with?(".rb")
        src_path = Dir.glob("#{@mod.root}/#{basename(file)}").first # existing source. IE: backend.rb in module folder
      end
      src_path ||= Dir.glob("#{Terraspace.root}/config/terraform/#{file}").first
      build_mod_file(src_path) if src_path
    end

    def build_mod_file(src_path)
      content = Strategy::Mod.new(@mod, src_path).run
      Writer.new(@mod, src_path: src_path).write(content)
    end

    def with_mod_file(&block)
      with_path("#{@mod.root}/**/*", &block) # Only all files
    end

    def with_path(path)
      Dir.glob(path).each do |src_path|
        next if skip?(src_path)
        yield(src_path)
      end
    end

    def skip?(src_path)
      return true unless File.file?(src_path)
      # certain folders will be skipped
      src_path.include?("#{@mod.root}/test")
    end
  end
end
