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
      klass_name = Terraspace::Provider.klass("Expander", backend: @name)
      klass_name.constantize if klass_name
    rescue NameError
      Terraspace::Provider::Expander::Generic
    end
  end
end
