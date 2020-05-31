module Terraspace
  module Provider
    extend Memoist

    # The provider metadata
    #
    # Example meta:
    #
    #    {
    #      "aws  => {root: "/path", backend: "s3"}
    #      "google" => {root: "/path", backend: "gcs"},
    #    }
    #
    @@meta = {}
    def meta
      @@meta
    end

    def layer_classes
      @@meta.map { |provider, data| data[:layer_class] }.compact
    end

    def config_instances
      @@meta.map { |provider, data| data[:config_instance] }.compact
    end

    # The resource map can be used to customized the mapping from the resource "first word" to the provider.
    #
    # resource map is in meta structure.
    #
    #    {
    #      "long_cloud_provider_name" => {resource_map: {"long_cloud_provider_name" => "short_name"}
    #    }
    #
    # This is use by Provider::Finder#find_with_resource
    # Allows mapping of different values in case the terraspace provider name doesnt match with the
    # resource first word.
    #
    # Generally we try to avoid this and the terraspace provider name should match the resource "first word"
    # when possible.
    #
    def resource_map
      @@meta.inject({}) do |result, (provider, data)|
        map = data[:resource_map] || {}
        result.merge(map.deep_stringify_keys)
      end
    end

    def register(provider, data)
      @@meta[provider] = data
    end

    # Example return:
    #
    #      TerraspaceProviderAws::Interfaces::Backend
    #      TerraspaceProviderAws::Interfaces::Expander
    #      TerraspaceProviderGcp::Interfaces::Backend
    #      TerraspaceProviderGcp::Interfaces::Expander
    #
    def klass(interface_class, options={})
      meta = find_with(options)
      return unless meta
      "TerraspaceProvider#{meta.provider}::Interfaces::#{interface_class}"
    end

    def find_with(options={})
      Finder.new.find_with(options)
    end
    memoize :find_with

    extend self
  end
end
