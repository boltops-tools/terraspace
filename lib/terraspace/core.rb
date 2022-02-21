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
    cattr_writer :root

    def cache_root
      ENV['TS_CACHE_ROOT'] || config.build.cache_root || "#{root}/.terraspace-cache"
    end
    memoize :cache_root

    def tmp_root
      ENV['TS_TMP_ROOT'] || "/tmp/terraspace"
    end
    memoize :tmp_root

    def log_root
      "#{root}/log"
    end

    def configure(&block)
      App.instance.configure(&block)
    end

    # Generally, use the Terraspace.config instead of App.instance.config since it guarantees the load_project_config call
    def config
      App.instance.load_project_config
      App.instance.config
    end
    memoize :config

    @@logger = nil
    def logger
      @@logger ||= config.logger
    end

    # allow different logger when running up all
    def logger=(v)
      @@logger = v
    end

    def pass_file?(path)
      pass_files = config.build.pass_files + config.build.default_pass_files
      pass_files.uniq.detect do |i|
        i.is_a?(Regexp) ? path =~ i : path.include?(i)
      end
    end

    # Terraspace.argv provides consistency when terraspace is being called by rspec-terraspace test harness
    # So use Terraspace.argv instead of ARGV constant
    cattr_accessor :argv
    cattr_accessor :check_project, default: true
  end
end
