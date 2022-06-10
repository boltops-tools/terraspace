module Terraspace::Compiler
  class Expander
    extend Memoist
    delegate :expand, :expansion, to: :expander

    def initialize(mod, backend=nil)
      @mod, @backend = mod, backend
    end

    def expander
      expander_class.new(@mod)
    end
    memoize :expander

    # IE: TerraspacePluginAws::Interfaces::Expander
    def expander_class
      class_name = expander_class_name
      class_name ? class_name.constantize : Terraspace::Plugin::Expander::Generic
    rescue NameError => e
      logger.debug "#{e.class}: #{e.message}"
      Terraspace::Plugin::Expander::Generic
    end

    def expander_class_name
      plugin = Terraspace.config.autodetect.expander # contains plugin name. IE: aws, azurerm, google
      if plugin
        # early return for user override of autodetection
        return Terraspace::Plugin.klass("Expander", plugin: plugin) # can return nil
      end

      backend = @backend || parse_backend
      class_name = Terraspace::Plugin.klass("Expander", backend: backend) # can return nil
      unless class_name
        backend = plugin_backend
        class_name = Terraspace::Plugin.klass("Expander", backend: backend) # can return nil
      end
      class_name
    end

    # autodetect by parsing backend.tf or backend.rb
    def parse_backend
      Backend.new(@mod).detect
    end

    # autodetect by looking up loaded plugins
    def plugin_backend
      plugin = Terraspace::Plugin.autodetect
      if plugin
        data = Terraspace::Plugin.meta[plugin]
        data[:backend] # IE: s3, azurerm, gcs
      end
    end

    class << self
      extend Memoist
      def autodetect(mod, opts={})
        new(mod, opts)
      end
      memoize :autodetect
    end
  end
end
