module Terraspace
  module Booter
    def boot
      Terraspace::Bundle.require # load providers
      load_plugin_default_configs
      Terraspace.config # load project config
    end

    def load_plugin_default_configs
      Terraspace::Plugin.config_instances.each do |instance|
        # IE: TerraspacePluginAws::Interfaces::Config.instance.load_project_config
        instance.load_project_config
      end
    end

    extend self
  end
end
