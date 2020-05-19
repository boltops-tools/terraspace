module Terraspace
  class Builder < Terraspace::CLI::Base
    def run
      Compiler::Cleaner.new(@mod).clean
      puts "Materializing #{Util.pretty_path(@mod.cache_build_dir)}"
      build_all("modules")
      build_all("stacks")
      Terraform::Runner.new("init", @options).run
      build_remote_dependencies # runs after terraform init, which downloads remote modules
    end

    def build_all(type_dir)
      built = []
      local_paths(type_dir).each do |path|
        next unless File.directory?(path)
        mod_name = File.basename(path)
        next if built.include?(mod_name) # ensures modules in app folder take higher precedence than vendor folder

        consider_stacks = type_dir == "stacks"
        mod = Mod.new(mod_name, consider_stacks: consider_stacks)
        mod.root_module = root?(mod)
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

    def root?(mod)
      mod.build_dir == @mod.build_dir
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

      remote_mod = Mod::Remote.new(meta, @mod)
      Compiler::Builder.new(remote_mod).build
    end

  private
    def local_source?(s)
       s =~ %r{^\.} || s =~ %r{^/}
    end
  end
end
