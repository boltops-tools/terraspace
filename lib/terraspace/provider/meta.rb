module Terraspace::Provider
  class Meta
    # raw: {"aws" => {root: "/path", backend: "s3"}
    def initialize(raw)
      @raw = raw
    end

    def name
      name = @raw.keys.first
      unless name
        raise "No provider found. Are you sure you have the terraspace_provider_XXX configured in your Gemfile?"
      end
      name.camelize
    end
    alias_method :provider, :name

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
