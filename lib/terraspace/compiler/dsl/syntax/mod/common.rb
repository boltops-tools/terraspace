module Terraspace::Compiler::Dsl::Syntax::Mod
  module Common
    extend Memoist

    Meta = Terraspace::Compiler::Dsl::Meta

    def var
      Meta::Var.new
    end
    memoize :var

    def local
      Meta::Local.new
    end
    memoize :local
  end
end
