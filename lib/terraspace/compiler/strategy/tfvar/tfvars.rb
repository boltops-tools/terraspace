class Terraspace::Compiler::Strategy::Tfvar
  class Tfvars < Base
    def run
      Terraspace::Compiler::Erb::Tfvars.new(@mod, @src_path).build
    end
  end
end
