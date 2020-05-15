module Terraspace::Compiler
  class Expander
    delegate :expand, :expand_string, to: :expander

    attr_reader :expander
    def initialize(mod, name)
      @mod, @name = mod, name
      @expander = state_class.new(@mod)
    end

    def state_class
      # Base is the generic class
      "Terraspace::Compiler::Expander::#{@name.camelize}".constantize rescue Base
    end
  end
end
