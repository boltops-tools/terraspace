class Terraspace::Compiler::Strategy::Tfvar
  class Rb < Base
    def run
      Terraspace::Compiler::Dsl::Tfvars.new(@mod, @src_path).build
    end
  end
end
