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
  end
end
