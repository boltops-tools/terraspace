module Terraspace::CLI::New::Source
  class Test < Base
    # different interface
    def set_source_paths(type)
      set_gem_source(type)   # test gems has templates
    end

    def set_gem_source(type)
      test_gem_name = "rspec/terraspace"

      require_gem(test_gem_name)
      tester = Terraspace::Tester.find_with(framework: Terraspace.config.test_framework)

      template_path = File.expand_path("#{tester.root}/lib/templates/#{type}")
      override_source_paths(template_path)
    end
  end
end
