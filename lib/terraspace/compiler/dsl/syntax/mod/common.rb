module Terraspace::Compiler::Dsl::Syntax::Mod
  module Common
    def var(name)
      "${var.#{name}}"
    end
  end
end
