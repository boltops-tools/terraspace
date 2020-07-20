module Terraspace
  module Plugin
    extend Memoist

    # The plugin metadata
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

    def config_classes
      @@meta.map { |plugin, data| data[:config_class] }.compact
    end

    def helper_classes
      @@meta.map { |plugin, data| data[:helper_class] }.compact
    end

    def layer_classes
      @@meta.map { |plugin, data| data[:layer_class] }.compact
    end

    # The resource map can be used to customized the mapping from the resource "first word" to the plugin.
    #
    # resource map is in meta structure.
    #
    #    {
    #      "long_cloud_plugin_name" => {resource_map: {"long_cloud_plugin_name" => "short_name"}
    #    }
    #
    # This is use by Plugin::Finder#find_with_resource
    # Allows mapping of different values in case the terraspace plugin name doesnt match with the
    # resource first word.
    #
    # Generally we try to avoid this and the terraspace plugin name should match the resource "first word"
    # when possible.
    #
    def resource_map
      @@meta.inject({}) do |result, (plugin, data)|
        map = data[:resource_map] || {}
        result.merge(map.deep_stringify_keys)
      end
    end

    def register(plugin, data)
      @@meta[plugin] = data
    end

    # Example return:
    #
    #      TerraspacePluginAws::Interfaces::Backend
    #      TerraspacePluginAws::Interfaces::Expander
    #      TerraspacePluginGcp::Interfaces::Backend
    #      TerraspacePluginGcp::Interfaces::Expander
    #
    def klass(interface_class, options={})
      meta = find_with(options)
      return unless meta
      "TerraspacePlugin#{meta.plugin}::Interfaces::#{interface_class}"
    end

    def find_with(options={})
      Finder.new.find_with(options)
    end
    memoize :find_with

    extend self
  end
end
