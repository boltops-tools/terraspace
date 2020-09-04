module Terraspace
  class Builder < Terraspace::CLI::Base
    def run
      Terraspace::CLI::CheckSetup.check!
      @mod.root_module = true
      Compiler::Cleaner.new(@mod, @options).clean if clean?
      build_dir = Util.pretty_path(@mod.cache_dir)
      logger.info "Building #{build_dir}"

      build_all("modules") # build all modules and stacks as dependencies
      build_all("stacks")
      build_root_module
      logger.info "Built in #{build_dir}"
    end

    def build_root_module
      Compiler::Builder.new(@mod).build
    end

    def build_all(type_dir)
      built = []
      local_paths(type_dir).each do |path|
        next unless File.directory?(path)
        mod_name = File.basename(path)
        next if built.include?(mod_name) # ensures modules in app folder take higher precedence than vendor folder

        consider_stacks = type_dir == "stacks"
        mod = Mod.new(mod_name, consider_stacks: consider_stacks)

        Compiler::Builder.new(mod).build
        built << mod_name
      end
    end

    def local_paths(type_dir)
      dirs("app/#{type_dir}/*") + dirs("vendor/#{type_dir}/*")
    end

    def dirs(path)
      Dir.glob("#{Terraspace.root}/#{path}")
    end

    def clean?
      clean_cache = Terraspace.config.build.clean_cache
      clean_cache.nil? ? true : clean_cache
    end
  end
end
