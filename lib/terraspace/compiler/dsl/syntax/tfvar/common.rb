module Terraspace::Compiler::Dsl::Syntax::Tfvar
  module Common
    def tfvar(name, value)
      @structure[name] = value
    end
  end
end
