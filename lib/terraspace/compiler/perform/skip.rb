class Terraspace::Compiler::Perform
  class Skip
    def initialize(mod, src_path)
      @mod, @src_path = mod, src_path
    end

    def check?
      return true unless File.file?(@src_path)

      # skip certain folders
      check_dirs?(
        "config/args",
        "config/helpers",
        "config/hooks",
        "test",
        "tfvars",
      )
    end

    def check_dirs?(*names)
      names.flatten.detect { |name| check_dir?(name) }
    end

    def check_dir?(name)
      @src_path.include?("#{@mod.root}/#{name}/")
    end
  end
end
