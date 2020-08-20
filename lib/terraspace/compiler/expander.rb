module Terraspace::Compiler
  class Expander
    delegate :expand, :expansion, to: :expander

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

    class << self
      extend Memoist

      def autodetect(mod, opts={})
        backend = opts[:backend]
        unless backend
          plugin = find_plugin
          backend = plugin[:backend]
        end
        new(mod, backend)
      end
      memoize :autodetect

      def find_plugin
        plugins = Terraspace::Plugin.meta
        if plugins.size == 1
          plugins.first[1]
        else
          precedence = %w[aws azurerm google]
          plugin = precedence.find do |provider|
            plugins[provider]
          end
          plugins[plugin]
        end
      end
    end
  end
end
