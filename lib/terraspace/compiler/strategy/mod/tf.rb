class Terraspace::Compiler::Strategy::Mod
  class Tf < Base
    def run
      Terraspace::Compiler::Erb::Mod.new(@mod, @src_path).build
    end
  end
end
