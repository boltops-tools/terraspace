module Terraspace::Plugin
  class Meta
    # raw: {"aws" => {root: "/path", backend: "s3"}
    def initialize(raw)
      @raw = raw
    end

    def name
      name = @raw.keys.first
      unless name
        raise "No plugin found. Are you sure you have the terraspace_plugin_XXX configured in your Gemfile?"
      end
      name.camelize
    end
    alias_method :plugin, :name

    def data
      @raw.values.first
    end

    def backend
      data[:backend]
    end

    def root
      data[:root]
    end
  end
end
