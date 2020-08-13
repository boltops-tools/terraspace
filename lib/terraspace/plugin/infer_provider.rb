module Terraspace::Plugin
  module InferProvider
    # Examples:
    #    TerraspacePluginAws     => aws
    #    TerraspacePluginAzurerm => azurerm
    #    TerraspacePluginGoogle  => google
    #
    # If multiple clouds used in a single Terraspace project. The TS_PROVIDER_EXPANSION env var provides a way to
    # change it. Can possibly use config hooks to set different values based on the module being deployed:
    # https://terraspace.cloud/docs/config/hooks/
    def provider
      ENV['TS_PROVIDER'] || self.class.to_s.split('::').first.sub('TerraspacePlugin','').underscore
    end
  end
end
