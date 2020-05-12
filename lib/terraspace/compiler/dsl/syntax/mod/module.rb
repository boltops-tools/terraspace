module Terraspace::Compiler::Dsl::Syntax::Mod
  module Module
    def module!(name, props={})
      output = @structure[:module] ||= {}
      output[name] = props
    end
    alias_method :mod, :module!
    alias_method :module, :module! # must use self.module to call because module is a keyword though
  end
end
