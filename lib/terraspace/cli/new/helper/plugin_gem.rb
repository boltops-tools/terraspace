module Terraspace::CLI::New::Helper
  module PluginGem
  private
    def plugin_gem_name
      if @options[:plugin_gem]
        @options[:plugin_gem]
      else
        "terraspace_plugin_#{@options[:plugin]}"
      end
    end
  end
end
