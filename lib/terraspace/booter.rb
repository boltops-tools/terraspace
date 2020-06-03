module Terraspace
  module Booter
    def boot
      Terraspace::Bundle.require # load plugins
      load_plugin_default_configs
      Terraspace.config # load project config
    end

    def load_plugin_default_configs
      Terraspace::Plugin.config_classes.each do |klass|
        # IE: TerraspacePluginAws::Interfaces::Config.instance.load_project_config
        klass.instance.load_project_config
      end
    end

    extend self
  end
end
