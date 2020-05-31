module Terraspace::Compiler
  class Expander
    delegate :expand, :expand_string, to: :expander

    attr_reader :expander
    def initialize(mod, name)
      @mod, @name = mod, name
      @expander = expander_class.new(@mod)
    end

    def expander_class
      # IE: TerraspacePluginAws::Interfaces::Expander
      klass_name = Terraspace::Plugin.klass("Expander", backend: @name)
      klass_name.constantize if klass_name
    rescue NameError
      Terraspace::Plugin::Expander::Generic
    end
  end
end
