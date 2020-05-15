module Terraspace::Compiler::Dsl::Meta
  class Local
    def method_missing(name, *args, &block)
      "${local.#{name}}"
    end
  end
end
