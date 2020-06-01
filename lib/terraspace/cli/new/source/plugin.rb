module Terraspace::CLI::New::Source
  class Plugin < Core
    # different interface than Source::Test
    #
    #     template: base, hcl, ruby
    #     type: module, project, stack
    #
    def set_source_paths(template, type)
      # project always uses the examples from the provider gem for configs
      # base always uses terraspace core templates
      # examples option always use examples from provider gems
      if (type == "project" || @options[:examples]) && template != "base"
        set_plugin_gem_source(template, type)   # provider gems has examples
      else
        set_core_source(template, type)  # terraspace core has empty starter files
      end
    end

  end
end
