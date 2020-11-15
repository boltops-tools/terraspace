class Terraspace::CLI::New
  class Hook < Thor::Group
    include Thor::Actions

    argument :stack, required: false

    def self.options
      [
        [:force, aliases: %w[y], type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:kind, default: "terraform", desc: "terraform or terraspace"],
        [:name, desc: "Command name. Defaults to apply for terraform kind and build for terraspace kind"],
        [:type, default: "project", desc: "project, stack or module"],
      ]
    end
    options.each { |args| class_option(*args) }

    def self.source_root
      File.expand_path("../../../templates/base/hook", __dir__)
    end

  private
    def kind
      valid_kinds = %w[terraform terraspace]
      kind = @options[:kind]
      valid_kinds.include?(kind) ? kind : "terraform" # fallback to terraform if user provides invalid type
    end

    def type
      valid_types = %w[project stack module]
      type = @options[:type]
      valid_types.include?(type) ? type : "project" # fallback to project if user provides invalid type
    end

    def name
      return options[:name] if options[:name]
      kind == "terraform" ? "apply" : "build"
    end

    def dest
      map = {
        project: "config/hooks",
        stack:   "app/stacks/#{stack}/config/hooks",
        module:  "app/modules/#{stack}/config/hooks",
      }
      map[type.to_sym]
    end

    def hook_path
      "#{dest}/#{kind}.rb"
    end

  public

    def check_stack_arg
      return if type == "project"
      return unless stack.nil?
      # Else check for STACK argument for type module or stack
      puts <<~EOL
        Required STACK argument, either the module or stack name. Usage:

            terraspace new hook STACK --type #{type}
      EOL
      exit 1
    end

    def create
      directory ".", dest
    end
  end
end
