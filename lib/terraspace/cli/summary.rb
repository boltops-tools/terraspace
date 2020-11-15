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
      build_placeholder
      puts "Summary of resources based on backend storage statefiles"
      backend_expr = '.terraspace-cache/**/backend.*'
      # Currently summary assumes backend are within the same bucket and key prefix
      backend = Dir.glob(backend_expr).find { |p| p.include?("/#{Terraspace.env}/") }
      process(backend) if backend
    end

    # Grab the last module and build that.
    # Assume the backend key has the same prefix
    def build_placeholder
      Build::Placeholder.new(@options).build
    end

    def process(path)
      ext = File.extname(path)
      code = IO.read(path)
      data = ext == ".tf" ? HclParser.load(code) : JSON.load(code)

      backend = data['terraform']['backend']
      name = backend.keys.first # backend name. IE: s3, gcs, azurerm

      info = backend.values.first # structure within the s3 or gcs key
      klass = summary_class(name)
      unless klass
        logger.info "Summary is unavailable for this backend: #{name}"
        exit
      end
      summary = klass.new(info, @options)
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
