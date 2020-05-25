module Terraspace::Compiler
  class Expander
    delegate :expand, :expand_string, to: :expander

    attr_reader :expander
    def initialize(mod, name)
      @mod, @name = mod, name
      @expander = expander_class.new(@mod)
    end

    def expander_class
      # IE: TerraspaceProviderAws::Interfaces::Expander
      klass_name = Terraspace::Provider.klass(@name, "Expander")
      klass_name.constantize
    # rescue NameError
    #   Terraspace::Provider::Expander::Generic
    end
  end
end
