module Terraspace
  module Booter
    def boot
      Dotenv.new.load!
      run_hooks
      Terraspace::Bundle.require # load plugins
      load_plugin_default_configs
      Terraspace::App::Inits.run_all
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

    # Special boot hooks run super early, even before plugins are loaded.
    # Useful for setting env vars and other early things.
    #
    #    config/boot.rb
    #    config/boot/dev.rb
    #
    def run_hooks
      run_hook
      run_hook(Terraspace.env)
    end

    def run_hook(env=nil)
      name = env ? "boot/#{env}" : "boot"
      path = "#{Terraspace.root}/config/#{name}.rb"
      require path if File.exist?(path)
    end

    extend self
  end
end
