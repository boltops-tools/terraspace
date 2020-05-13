require 'thor'

class Terraspace::New
  class Sequence < Thor::Group
    include Thor::Actions
    include Helper

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
    def set_source(type, blank: false)
      provider = blank ? "blank" : options[:provider]
      template_path = File.expand_path("../../templates/#{@options[:lang]}/#{provider}/#{type}", __dir__)
      override_source_paths(template_path)
    end

    def set_base_source(type)
      template_path = File.expand_path("../../templates/base/#{type}", __dir__)
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
