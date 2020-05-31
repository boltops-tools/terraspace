module Terraspace
  module Core
    extend Memoist

    def env
      ENV['TS_ENV'] || "dev"
    end
    memoize :env

    @@root = nil
    def root
      @@root ||= ENV['TS_ROOT'] || Dir.pwd
    end

    # allow testing frameworks to switch roots
    def root=(v)
      @@root = v
    end

    def cache_root
      ENV['TS_CACHE_ROOT'] || "#{root}/.terraspace-cache"
    end
    memoize :cache_root

    def tmp_root
      ENV['TS_TMP_ROOT'] || "/tmp/terraspace"
    end
    memoize :tmp_root

    def configure(&block)
      App.instance.configure(&block)
    end

    # Generally, use the Terraspace.config instead of App.instance.config since it guarantees the load_project_config call
    def config
      App.instance.load_project_config
      App.instance.config
    end
    memoize :config
  end
end
