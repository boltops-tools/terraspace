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
    def klass(backend, interface_class)
      meta = find_with(backend: backend)
      "TerraspaceProvider#{meta.provider}::Interfaces::#{interface_class}"
    end

    def find_with(options={})
      Finder.new(options).find
    end
    memoize :find_with

    extend self
  end
end
