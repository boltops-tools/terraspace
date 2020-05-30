module Terraspace
  module Provider
    extend Memoist

    # The provider metadata
    #
    # Example meta:
    #
    #    {
    #      "aws  => {root: "/path", backend: "s3",
    #      "gcp" => {root: "/path", backend: "gcs",
    #    }
    #
    @@meta = {}
    def meta
      @@meta
    end

    # resource map is in meta structure
    #
    #    {
    #      "gcp" => {root: "/path", backend: "gcs", resource_map: {"google" => "gcp"}
    #    }
    #
    # This is use by Provider::Finder#find_with_resource
    # Allows mapping of different values in case the terraspace provider name doesnt match with the
    # resource first word.
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
