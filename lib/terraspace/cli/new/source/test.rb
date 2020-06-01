module Terraspace::CLI::New::Source
  class Test < Core
    # different interface than Source::Plugin
    #
    #     template: base, hcl, ruby
    #     type: module, project, stack
    #
    def set_source_paths(template, type)
      if @options[:examples]
        set_plugin_gem_source("test", type)
      else
        set_test_framework_gem_source(type) # tester gem like rspec-terraspace has empty starter templates
      end
    end

    def set_test_framework_gem_source(type)
      test_gem_name = "rspec/terraspace"

      require_gem(test_gem_name)
      tester = Terraspace::Tester.find_with(framework: Terraspace.config.test_framework)

      template_path = File.expand_path("#{tester.root}/lib/templates/#{type}")
      override_source_paths(template_path)
    end
  end
end
