module Terraspace::Compiler
  class Expander
    extend Memoist
    delegate :expand, :expansion, to: :expander

    def initialize(mod, name)
      @mod, @name = mod, name
    end

    def expander
      expander_class.new(@mod)
    end
    memoize :expander

    def expander_class
      # IE: TerraspacePluginAws::Interfaces::Expander
      klass_name = Terraspace::Plugin.klass("Expander", backend: @name)
      klass_name ? klass_name.constantize : Terraspace::Plugin::Expander::Generic
    rescue NameError
      Terraspace::Plugin::Expander::Generic
    end

    class << self
      extend Memoist

      def autodetect(mod, opts={})
        backend = opts[:backend] || find_backend(mod)
        new(mod, backend)
      end
      memoize :autodetect

      def find_backend(mod)
        Backend.new(mod).detect
      end
      memoize :find_backend
    end
  end
end
