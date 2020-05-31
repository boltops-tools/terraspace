module Terraspace
  module Booter
    def boot
      Terraspace::Bundle.require # load providers
      load_provider_default_configs
      Terraspace.config # load project config
    end

    def load_provider_default_configs
      Terraspace::Provider.config_instances.each do |instance|
        # IE: TerraspaceProviderAws::Interfaces::Config.instance.load_project_config
        instance.load_project_config
      end
    end

    extend self
  end
end
