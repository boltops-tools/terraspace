module Terraspace::Compiler
  class Builder
    def initialize(mod)
      @mod = mod
    end

    def build
      build_config
      build_module
    end

    # build common config files: provider and backend for the root module
    def build_config
      return unless @mod.root_module?
      build_config_templates
    end

    # build all module .rb to .tf.json files
    def build_module
      build_mod_files
      build_tfvars
    end

    def build_mod_files
      with_mod_file do |src_path|
        build_mod_file(src_path)
      end
    end

    def build_tfvars
      Strategy::Tfvar.new(@mod).run # writer within Strategy to control file ordering
    end

  private
    def build_config_templates
      expr = "#{Terraspace.root}/config/terraform/*.{tf,rb,tfvars}"
      Dir.glob(expr).each do |path|
        build_config_file(File.basename(path))
      end
    end

    def build_config_file(file)
      existing = !!Dir.glob("#{@mod.root}/#{file}").first
      return if existing && existing.ends_with?(".tf") # do not overwrite existing backend.tf, provider.tf, etc

      if file.ends_with?(".rb")
        src_path = Dir.glob("#{@mod.root}/#{File.basename(file)}").first # existing source. IE: backend.rb in module folder
      end
      src_path ||= Dir.glob("#{Terraspace.root}/config/terraform/#{file}").first
      build_mod_file(src_path) if src_path
    end

    def build_mod_file(src_path)
      content = Strategy::Mod.new(@mod, src_path).run
      Writer.new(@mod, src_path: src_path).write(content)
    end

    def with_mod_file(&block)
      with_path("#{@mod.root}/*", &block) # Only build top-level files
    end

    def with_path(path)
      Dir.glob(path).each do |src_path|
        next unless File.file?(src_path)
        yield(src_path)
      end
    end
  end
end
