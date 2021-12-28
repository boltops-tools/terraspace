require "terraspace/bundle"
Terraspace::Bundle.setup
begin
  require "zeitwerk"
rescue LoadError => e
  Terraspace::Bundle.handle_already_activated_error(e)
end

module Terraspace
  # These modules are namespaces for user-defined custom helpers
  module Module; end
  module Project; end
  module Stack; end

  class Autoloader
    class Inflector < Zeitwerk::Inflector
      def camelize(basename, _abspath)
        map = { cli: "CLI", version: "VERSION" }
        map[basename.to_sym] || super
      end
    end

    class << self
      def setup
        loader = Zeitwerk::Loader.new
        loader.inflector = Inflector.new
        loader.push_dir(File.dirname(__dir__)) # lib
        loader.push_dir(project_helpers, namespace: Terraspace::Project) if File.exist?(project_helpers)
        loader.log! if ENV["TS_AUTOLOAD_LOG"]
        loader.ignore("#{__dir__}/ext.rb")
        loader.setup
      end

      def project_helpers
        "#{ts_root}/config/helpers"
      end

      # Duplicate definition because autoloader logic runs very early and doesnt have access to core methods yet
      def ts_root
        ENV['TS_ROOT'] || Dir.pwd
      end
    end
  end
end

