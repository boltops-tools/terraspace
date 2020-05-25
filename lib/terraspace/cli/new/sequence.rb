require 'thor'

class Terraspace::CLI::New
  class Sequence < Thor::Group
    include Thor::Actions

    def self.base_options
      [
        [:examples, type: :boolean, default: false, desc: "Also generate examples"],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files."],
        [:lang, default: "hcl", desc: "Language to use: HCL/ERB or Ruby DSL"],
        [:provider, default: "aws", desc: "Cloud Provider. Supports: aws, gcp"],
      ]
    end

    def self.component_options
      [
        [:project_name, desc: "Only used internally", hide: true],
      ]
    end

    base_options.each { |args| class_option(*args) }

    argument :name

  private
    def component_args(component_name, project_name)
      args = [
        component_name,
        "--project-name", project_name,
        "--lang", options[:lang],
        "--provider", options[:provider],
      ]
      args << "--force" if @options[:force]
      args << "--examples" if @options[:examples]
      args
    end

    # friendly method
    def set_source(type, blank: true)
      # always use gem source. no blank slate for project generator
      if blank && type != "project"
        template_path = File.expand_path("../../../templates/#{@options[:lang]}/#{type}", __dir__)
        override_source_paths(template_path)
      else
        set_gem_source(type) # provider has examples
      end
    end

    def set_base_source(*types)
      template_paths = types.flatten.map do |type|
        File.expand_path("../../../templates/base/#{type}", __dir__)
      end
      override_source_paths(template_paths)
    end

    def set_gem_source(type)
      provider_name = options[:provider]
      require "terraspace_provider_#{provider_name}" # require provider for the templates, this registers the provider

      provider = Terraspace::Provider.find_with(provider: provider_name)
      template_path = File.expand_path("#{provider.root}/lib/templates/#{options[:lang]}/#{type}")
      override_source_paths(template_path)
    end

    def override_source_paths(*paths)
      # Using string with instance_eval because block doesnt have access to path at runtime.
      self.class.instance_eval %{
        def self.source_paths
          #{paths.flatten.inspect}
        end
      }
    end
  end
end
