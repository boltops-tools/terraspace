class Terraspace::Compiler::Strategy::Mod
  class Pass < Base
    def run
      IO.read(@src_path)
    end
  end
end
