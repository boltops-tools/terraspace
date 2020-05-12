module Terraspace::Compiler::Dsl::Syntax::Mod
  module Locals
    def locals(props={})
      @structure[:locals] ||= props
    end
  end
end
