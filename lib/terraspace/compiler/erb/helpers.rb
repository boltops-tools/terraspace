module Terraspace::Compiler::Erb
  module Helpers
    include Terraspace::Compiler::Dsl::Syntax::Mod
    include Terraspace::Compiler::Dependencies::Helpers
    include Terraspace::Cloud::Helpers
  end
end
