module Terraspace
  module Booter
    def boot
      Terraspace::Bundle.require # load plugins
      load_plugin_default_configs
      Terraspace.config # load project config
      Terraspace::App::Hooks.run_hook(:on_boot)
      set_plugin_cache!
    end

    def load_plugin_default_configs
      Terraspace::Plugin.config_classes.each do |klass|
        # IE: TerraspacePluginAws::Interfaces::Config.instance.load_project_config
        klass.instance.load_project_config
      end
    end

    def set_plugin_cache!
      plugin_cache = Terraspace.config.terraform.plugin_cache
      return unless plugin_cache.enabled
      dir = ENV['TF_PLUGIN_CACHE_DIR'] ||= plugin_cache.dir
      FileUtils.mkdir_p(dir)
      dir
    end

    extend self
  end
end
