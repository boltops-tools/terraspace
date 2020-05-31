module Terraspace::Plugin
  class Finder
    def find_with(options)
      result = if options.key?(:plugin)
                 find_with_plugin(options[:plugin])
               elsif options.key?(:backend)
                 find_with_backend(options[:backend])
               elsif options.key?(:resource)
                 find_with_resource(options[:resource])
               else
                 raise "Must provide backend, provider, or resource option."
               end
      return unless result
      raw = Hash[*result] # convert result to Hash instead of an Array
      Meta.new(raw)
    end

    def find_with_backend(backend)
      meta.find do |provider, data|
        data[:backend] == backend
      end
    end

    def find_with_plugin(plugin)
      meta.find do |plugin_name, data|
        plugin_name == plugin
      end
    end

    def find_with_resource(resource)
      map = resource_map
      base = resource.split('_').first # google_compute_firewall => google, aws_security_group => aws
      provider = map[base] || base
      find_with_provider(provider)
    end

    def resource_map
      Terraspace::Plugin.resource_map
    end

    def meta
      Terraspace::Plugin.meta
    end
  end
end
