module Terraspace
  module Core
    extend Memoist

    def app
      ENV['TS_APP'] unless ENV['TS_APP'].blank?
    end

    def role
      ENV['TS_ROLE'] unless ENV['TS_ROLE'].blank?
    end

    def env
      ENV['TS_ENV'].blank? ? "dev" : ENV['TS_ENV']
    end

    def extra
      ENV['TS_EXTRA'] unless ENV['TS_EXTRA'].blank?
    end

    def project
      if ENV['TS_PROJECT'].blank?
        config.cloud.project
      else
        ENV['TS_PROJECT']
      end
    end

    @@root = nil
    def root
      @@root ||= ENV['TS_ROOT'] || Dir.pwd
    end
    # allow testing frameworks to switch roots
    cattr_writer :root

    def cache_root
      ENV['TS_CACHE_ROOT'] || "#{root}/.terraspace-cache"
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

    @@cloud_warning_shown = false
    def cloud?
      enabled = !!Terraspace.config.cloud.org
      if ENV['TS_TOKEN'] && !enabled && !@@cloud_warning_shown
        logger.warn <<~EOL.color(:yellow)
          WARN: TS_TOKEN is set but config.cloud.org is not set.
          See: http://terraspace.cloud/docs/cloud/setup/
        EOL
        @@cloud_warning_shown = true
      end
      enabled
    end

    @@buffer = []
    def buffer
      @@buffer
    end

    def command?(name)
      ARGV[0] == name || ARGV[1] == name
    end
  end
end
