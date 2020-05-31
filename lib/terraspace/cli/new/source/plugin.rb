module Terraspace::CLI::New::Source
  class Plugin < Base
    # different interface
    def set_source_paths(template, type)
      # project always uses the examples from the provider gem for configs
      # base always uses terraspace core templates
      # examples option always use examples from provider gems
      if (type == "project" || @options[:examples]) && template != "base"
        set_gem_source(template, type)   # provider gems has examples
      else
        set_core_source(template, type)  # terraspace core has empty starter files
      end
    end

    def set_gem_source(template, type)
      require_gem(plugin_gem_name)
      plugin = Terraspace::Plugin.find_with(plugin: @options[:plugin])
      template_name = template_name(template, type)
      template_path = File.expand_path("#{plugin.root}/lib/templates/#{template_name}")
      override_source_paths(template_path)
    end

    def template_name(template, type)
      if template == "test"
        "#{template}/#{Terraspace.config.test_framework}/#{type}"
      else
        "#{template}/#{type}"       # IE: hcl/module
      end
    end

  end
end
