module Terraspace
  module Core
    extend Memoist

    def env
      ENV['TS_ENV'] || "dev"
    end
    memoize :env

    def root
      ENV['TS_ROOT'] || Dir.pwd
    end
    memoize :root

    def cache_root
      ENV['TS_CACHE_ROOT'] || "#{root}/.terraspace-cache"
    end
    memoize :cache_root

    def tmp_root
      ENV['TS_TMP_ROOT'] || "/tmp/terraspace"
    end
    memoize :tmp_root

    def app
      App.instance
    end

    def configure(&block)
      app.configure(&block)
    end

    # The load_project_config is called in here instead of in app method because in app it causes an infinite loop
    # Generally, we should use the Terraspace.config.
    def config
      app.load_project_config
      app.config
    end
    memoize :config
  end
end
