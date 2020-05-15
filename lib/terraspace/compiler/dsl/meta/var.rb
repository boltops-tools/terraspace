module Terraspace::Compiler::Dsl::Meta
  class Var
    def method_missing(name, *args, &block)
      "${var.#{name}}"
    end
  end
end
