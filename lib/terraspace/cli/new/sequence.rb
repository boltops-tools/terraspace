require 'thor'

class Terraspace::CLI::New
  class Sequence < Thor::Group
    include Thor::Actions
    include Helper

    def self.base_options
      [
        [:examples, type: :boolean, default: false, desc: "Also generate examples"],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:lang, default: "hcl", desc: "Language to use: HCL/ERB or Ruby DSL"],
        [:provider, default: "aws", desc: "Cloud Provider. Supports: aws, google"],
        [:provider_gem, desc: "Useful if provider gem name doesnt follow terraspace_provider_XXX naming convention"],
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
    def set_source(template, type)
      source = Source.new(self, @options)
      source.set_source_paths(template, type)
    end
  end
end
