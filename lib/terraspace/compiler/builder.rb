module Terraspace::Compiler
  class Builder
    include CommandsConcern
    include Basename

    def initialize(mod)
      @mod = mod
    end

    def build
      build_config
      build_module if @mod.resolved
      build_tfvars unless command_is?(:seed) #  avoid dependencies being built and erroring when backend bucket doesnt exist
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
      search(expr).each do |path|
        next unless File.file?(path)
        next if path.include?('config/terraform/tfvars')
        build_config_file(basename(path))
      end
    end

    def build_config_file(file)
      existing = search("#{@mod.root}/#{file}").first
      return if existing && existing.ends_with?(".tf") # do not overwrite existing backend.tf, provider.tf, etc

      if file.ends_with?(".rb")
        src_path = search("#{@mod.root}/#{basename(file)}").first # existing source. IE: backend.rb in module folder
      end
      src_path ||= search("#{Terraspace.root}/config/terraform/#{file}").first
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
      search(path).each do |src_path|
        next if skip?(src_path)
        yield(src_path)
      end
    end

    def skip?(src_path)
      return true unless File.file?(src_path)
      # certain folders will be skipped
      src_path.include?("#{@mod.root}/config/args") ||
      src_path.include?("#{@mod.root}/config/helpers") ||
      src_path.include?("#{@mod.root}/config/hooks") ||
      src_path.include?("#{@mod.root}/test") ||
      src_path.include?("#{@mod.root}/tfvars")
    end

    def search(expr)
      Dir.glob(expr, File::FNM_DOTMATCH)
    end
  end
end
