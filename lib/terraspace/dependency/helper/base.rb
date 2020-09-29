module Terraspace::Dependency::Helper
  class Base
    def initialize(mod, identifier, options)
      @mod, @identifier, @options = mod, identifier, options
    end
  end
end
