module Terraspace::Compiler::Dsl::Syntax::Mod
  module Provider
    def provider(name, props={})
      provider = @structure[:provider] ||= []
      provider << {name => props}
    end
  end
end
