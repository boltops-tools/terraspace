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
      build_config_file("backend")
      build_config_file("provider")
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
    def build_config_file(type)
      src_path = Dir.glob("#{Terraspace.root}/config/#{type}*").first
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
