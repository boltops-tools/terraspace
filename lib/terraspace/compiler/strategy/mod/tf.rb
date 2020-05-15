class Terraspace::Compiler::Strategy::Mod
  class Tf < Base
    def run
      Terraspace::Compiler::Erb::Render.new(@mod, @src_path).build
    end
  end
end
