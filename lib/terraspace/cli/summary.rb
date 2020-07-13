require "hcl_parser"
require "json"
require "pathname"

class Terraspace::CLI
  class Summary
    include Terraspace::Util::Logging

    def initialize(options={})
      @options = options
    end

    def run
      build
      puts "Summary of resources based on backend storage statefiles"
      backend_expr = '.terraspace-cache/**/backend.*'
      backends = Dir.glob(backend_expr)
      backends.each do |backend|
        process(backend)
      end
    end

    # Grab the last module and build that.
    # Assume the backend key has the same prefix
    def build
      return if ENV['TS_SUMMARY_BUILD'] == '0'

      mod = @options[:mod]
      unless mod
        mod_path = Dir.glob("{app,vendor}/{modules,stacks}/*").last
        mod = File.basename(mod_path)
      end
      Build.new(@options.merge(mod: mod)).run # generate and init
    end

    def process(path)
      ext = File.extname(path)
      code = IO.read(path)
      data = ext == ".tf" ? HclParser.load(code) : JSON.load(code)

      backend = data['terraform']['backend']
      name = backend.keys.first # backend name. IE: s3, gcs, azurerm

      info = backend.values.first # structure within the s3 or gcs key
      klass = summary_class(name)
      summary = klass.new(info)
      summary.call
    end

    def summary_class(name)
      return unless name
      # IE: TerraspacePluginAws::Interfaces::Summary
      klass_name = Terraspace::Plugin.klass("Summary", backend: name)
      klass_name.constantize if klass_name
    rescue NameError => e
      logger.error "#{e.class}: #{e.message}"
      logger.error "ERROR: No summary class implementation provided by plugins installed for this backend: #{name}".color(:red)
      exit 1
    end
  end
end
