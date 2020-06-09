module Terraspace
  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    yes_option = Proc.new {
      option :yes, aliases: :y, type: :boolean, desc: "-auto-approve the terraform apply"
    }
    format_option = Proc.new {
      option :format, desc: "output formats: json, text"
    }
    out_option = Proc.new {
      option :out, aliases: :o, desc: "write the output to path"
    }
    input_option = Proc.new {
      option :input, type: :boolean, desc: "Ask for input for variables if not directly set."
    }
    auto_option = Proc.new {
      option :auto, type: :boolean, desc: "Auto mode is useful for CI automation. It enables appropriate flags."
    }
    instance_option = Proc.new {
      option :instance, aliases: %w[i], default: "default", desc: "Instance of stack"
    }

    desc "new SUBCOMMAND", "new subcommands"
    long_desc Help.text(:new)
    subcommand "new", New

    desc "build MODULE", "build"
    long_desc Help.text(:build)
    option :quiet, type: :boolean, default: true, desc: "quiet output"
    input_option.call
    auto_option.call
    instance_option.call
    def build(mod)
      Build.new(options.merge(mod: mod)).run
    end

    desc "check_setup", "check_setup"
    long_desc Help.text(:check_setup)
    def check_setup
      CheckSetup.new(options).run
    end

    desc "clean", "clean .terraspace-cache dir"
    long_desc Help.text(:clean)
    def clean
      Clean.new(options).run
    end

    desc "console", "console .terraspace-cache dir"
    long_desc Help.text(:console)
    instance_option.call
    def console(mod)
      Commander.new("console", options.merge(mod: mod)).run
    end

    desc "down MODULE", "down"
    long_desc Help.text(:down)
    instance_option.call
    yes_option.call
    def down(mod)
      Commander.new("destroy", options.merge(mod: mod)).run
    end

    desc "info MODULE", "info"
    long_desc Help.text(:info)
    format_option.call
    instance_option.call
    def info(mod)
      Info.new(options.merge(mod: mod)).run
    end

    desc "plan MODULE", "plan module"
    long_desc Help.text(:plan)
    auto_option.call
    input_option.call
    instance_option.call
    out_option.call
    def plan(mod)
      Commander.new("plan", options.merge(mod: mod)).run
    end

    desc "providers MODULE", "providers"
    long_desc Help.text(:providers)
    instance_option.call
    def providers(mod)
      Commander.new("providers", options.merge(mod: mod)).run
    end

    desc "refresh", "refresh"
    long_desc Help.text(:refresh)
    instance_option.call
    def refresh(mod)
      Commander.new("refresh", options.merge(mod: mod)).run
    end

    desc "seed MODULE", "seed"
    long_desc Help.text(:seed)
    option :yes, aliases: :y, type: :boolean, desc: "bypass prompts and force overwrite files"
    option :where, desc: "where to create file. either under app or seed folder structure. values: app or stack"
    instance_option.call
    def seed(mod)
      Seed.new(options.merge(mod: mod)).run
    end

    desc "show MODULE", "show"
    long_desc Help.text(:show)
    instance_option.call
    def show(mod)
      Commander.new("show", options.merge(mod: mod)).run
    end

    desc "test", "test"
    long_desc Help.text(:test)
    def test
      Test.new(options).run
    end

    desc "output MODULE", "output"
    long_desc Help.text(:output)
    format_option.call
    instance_option.call
    out_option.call
    def output(mod)
      Commander.new("output", options.merge(mod: mod)).run
    end

    desc "update MODULE", "Update infrasturcture. IE: apply plan"
    long_desc Help.text(:update)
    input_option.call
    auto_option.call
    instance_option.call
    yes_option.call
    option :plan, desc: "Execution plan that can be used to only execute a pre-determined set of actions."
    option :var_files, type: :array, desc: "list of var files"
    def update(mod)
      Commander.new("apply", options.merge(mod: mod, command: "update")).run
    end

    desc "validate MODULE", "validate"
    long_desc Help.text(:validate)
    instance_option.call
    def validate(mod)
      Commander.new("validate", options.merge(mod: mod)).run
    end

    desc "completion *PARAMS", "Prints words for auto-completion."
    long_desc Help.text(:completion)
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    desc "completion_script", "Generates a script that can be eval to setup auto-completion."
    long_desc Help.text(:completion_script)
    def completion_script
      Completer::Script.generate
    end

    desc "version", "prints version"
    def version
      puts VERSION
    end
  end
end
