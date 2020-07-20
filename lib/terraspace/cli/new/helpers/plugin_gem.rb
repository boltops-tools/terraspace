module Terraspace::CLI::New::Helpers
  module PluginGem
  private
    def plugin_gem_name
      if @options[:plugin_gem]
        @options[:plugin_gem]
      else
        plugin = @options[:plugin] || autodetect_provider
        "terraspace_plugin_#{plugin}"
      end
    end

    def autodetect_provider
      providers = Terraspace::Plugin.meta.keys
      if providers.size == 1
        providers.first
      else
        precedence = %w[aws azurerm google]
        precedence.find do |p|
          providers.include?(p)
        end
      end
    end
  end
end
