module Terraspace
  class Build < AbstractBase
    def run
      Compiler::Cleaner.new(@mod).clean
      build_root_module
      build_local_modules
      Terraform::Init.new(@options).run
      build_remote_dependencies # runs after terraform init, which downloads remote modules
    end

    def build_root_module
      @mod.root_module = true
      puts "Materializing #{Terraspace::Util.pretty_path(@mod.cache_build_dir)}"
      Compiler::Builder.new(@mod).build # top-level
    end

    def build_local_modules
      built = []
      local_mod_paths.each do |path|
        next unless File.directory?(path)
        mod_name = File.basename(path)
        next if @mod.name == mod_name # skip root module because already built
        next if built.include?(mod_name) # ensures app/modules take higher precedence than vendor/modules

        mod = Terraspace::Mod.new(mod_name)
        Compiler::Builder.new(mod).build
        built << mod_name
      end
    end

    def local_mod_paths
      dirs("app/modules/*") + dirs("vendor/modules/*")
    end

    def dirs(path)
      Dir.glob("#{Terraspace.root}/#{path}")
    end

    # Currently only handles remote modules only one-level deep.
    def build_remote_dependencies
      modules_json_path = "#{@mod.cache_build_dir}/.terraform/modules/modules.json"
      return unless File.exist?(modules_json_path)

      initialized_modules = JSON.load(IO.read(modules_json_path))
      # For example of structure see spec/fixtures/initialized/modules.json
      initialized_modules["Modules"].each do |meta|
        build_remote_mod(meta)
      end
    end

    def build_remote_mod(meta)
      return if local_source?(meta["Source"])
      return if meta['Dir'] == '.' # root is already built

      remote_mod = Terraspace::Mod::Remote.new(meta, @mod)
      Compiler::Builder.new(remote_mod).build
    end

  private
    def local_source?(s)
       s =~ %r{^\.} || s =~ %r{^/}
    end
  end
end
