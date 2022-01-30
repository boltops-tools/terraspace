module Terraspace::Compiler
  class Perform
    include CommandsConcern
    include Basename

    def initialize(mod)
      @mod = mod
    end

    def compile
      compile_config
      compile_module if @mod.resolved
      compile_tfvars
    end

    # compile common config files: provider and backend for the root module
    def compile_config
      return unless compile?
      compile_config_terraform
    end

    def compile_module
      with_mod_file do |src_path|
        compile_mod_file(src_path)
      end
    end

    def compile_tfvars(write: true)
      return unless compile?
      return if command_is?(:seed) # avoid dependencies being built and erroring when backend bucket doesnt exist
      Strategy::Tfvar.new(@mod).run(write: write) # writer within Strategy to control file ordering
    end

  private
    def compile?
      @mod.type == "stack" || @mod.root_module?
    end

    def compile_config_terraform
      expr = "#{Terraspace.root}/config/terraform/**/*"
      search(expr).each do |path|
        next unless File.file?(path)
        next if path.include?('config/terraform/tfvars')
        compile_config_file(basename(path))
      end
    end

    def compile_config_file(file)
      existing = search("#{@mod.root}/#{file}").first
      return if existing && existing.ends_with?(".tf") # do not overwrite existing backend.tf, provider.tf, etc

      if file.ends_with?(".rb")
        src_path = search("#{@mod.root}/#{basename(file)}").first # existing source. IE: backend.rb in module folder
      end
      src_path ||= search("#{Terraspace.root}/config/terraform/#{file}").first
      compile_mod_file(src_path) if src_path
    end

    def compile_mod_file(src_path)
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
      Skip.new(@mod, src_path).check?
    end

    def search(expr)
      Dir.glob(expr, File::FNM_DOTMATCH)
    end
  end
end
