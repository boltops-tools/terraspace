class Terraspace::Compiler::Strategy::Mod
  class Rb < Base
    def run
      Terraspace::Compiler::Dsl::Mod.new(@mod, @src_path).build
    end
  end
end
