class Terraspace::CLI::New
  class Arg < Thor::Group
    include Thor::Actions

    argument :stack, required: false

    def self.options
      [
        [:force, aliases: %w[y], type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:name, default: "apply", desc: "command name"],
        [:type, default: "project", desc: "project, stack or module"],
      ]
    end
    options.each { |args| class_option(*args) }

    def self.source_root
      File.expand_path("../../../templates/base/arg", __dir__)
    end

  private
    def type
      valid_types = %w[project stack module]
      type = @options[:type]
      valid_types.include?(type) ? type : "project" # fallback to project if user provides invalid type
    end

    def name
      options[:name] ?  options[:name] : "apply"
    end

    def dest
      map = {
        project: "config/args",
        stack:   "app/stacks/#{stack}/config/args",
        module:  "app/modules/#{stack}/config/args",
      }
      map[type.to_sym]
    end

    def arg_path
      "#{dest}/#{kind}.rb"
    end

  public

    def check_stack_arg
      return if type == "project"
      return unless stack.nil?
      # Else check for STACK argument for type module or stack
      puts <<~EOL
        Required STACK argument, either the module or stack name. Usage:

            terraspace new arg STACK --type #{type}
      EOL
      exit 1
    end

    def create
      directory ".", dest
    end
  end
end
