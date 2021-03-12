class Terraspace::CLI::New
  class Helper < Thor::Group
    include Thor::Actions

    argument :stack

    def self.options
      [
        [:force, aliases: %w[y], type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:name, desc: "Helper name used for the filename. Defaults to the project, module or stack name"],
        [:type, default: "project", desc: "project, stack or module"],
      ]
    end
    options.each { |args| class_option(*args) }

    def self.source_root
      File.expand_path("../../../templates/base/helper", __dir__)
    end

  private
    def type
      valid_types = %w[project stack module]
      type = @options[:type]
      valid_types.include?(type) ? type : "project" # fallback to project if user provides invalid type
    end

    def helper_class
      if type == "project"
        "Terraspace::#{type.camelcase}::#{name.camelcase}Helper"
      else
        "Terraspace::#{type.camelcase}::#{stack.camelcase}::#{name.camelcase}Helper"
      end
    end

    def name
      options[:name] || stack
    end

    def dest
      map = {
        project: "config/helpers",
        stack:   "app/stacks/#{stack}/config/helpers",
        module:  "app/modules/#{stack}/config/helpers",
      }
      map[type.to_sym]
    end

  public

    def create
      directory ".", dest
    end
  end
end
