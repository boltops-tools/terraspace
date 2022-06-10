module Terraspace::CLI::New::Helpers
  module PluginGem
  private
    def plugin_gem_name
      if @options[:plugin_gem]
        @options[:plugin_gem]
      else
        plugin = @options[:plugin] || Terraspace::Plugin.autodetect
        "terraspace_plugin_#{plugin}" if plugin and plugin != "none"
      end
    end
  end
end
