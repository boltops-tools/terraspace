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

    desc "new SUBCOMMAND", "new subcommands"
    long_desc Help.text(:new)
    subcommand "new", New

    desc "build MODULE", "build"
    long_desc Help.text(:build)
    option :quiet, type: :boolean, default: true, desc: "quiet output"
    def build(mod)
      Build.new(options.merge(mod: mod)).run
    end

    desc "clean", "clean .terraspace-cache dir"
    long_desc Help.text(:clean)
    def clean
      Clean.new(options).run
    end

    desc "console", "console .terraspace-cache dir"
    long_desc Help.text(:console)
    def console(mod)
      Commander.new("console", options.merge(mod: mod)).run
    end

    desc "down MODULE", "down"
    long_desc Help.text(:down)
    yes_option.call
    def down(mod)
      Commander.new("destroy", options.merge(mod: mod)).run
    end

    desc "info MODULE", "info"
    long_desc Help.text(:info)
    format_option.call
    def info(mod)
      Info.new(options.merge(mod: mod)).run
    end

    desc "plan MODULE", "plan module"
    long_desc Help.text(:plan)
    option :out, desc: "Write a plan file to the given path"
    def plan(mod)
      Commander.new("plan", options.merge(mod: mod)).run
    end

    desc "providers MODULE", "providers"
    long_desc Help.text(:providers)
    def providers(mod)
      Commander.new("providers", options.merge(mod: mod)).run
    end

    desc "refresh", "refresh"
    long_desc Help.text(:refresh)
    def refresh(mod)
      Commander.new("refresh", options.merge(mod: mod)).run
    end

    desc "seed MODULE", "seed"
    long_desc Help.text(:seed)
    option :yes, aliases: :y, type: :boolean, desc: "bypass prompts and force overwrite files"
    option :where, desc: "where to create file. either under app or seed folder structure. values: app or stack"
    def seed(mod)
      Seed.new(options.merge(mod: mod)).run
    end

    desc "show MODULE", "show"
    long_desc Help.text(:show)
    def show(mod)
      Commander.new("show", options.merge(mod: mod)).run
    end

    desc "output MODULE", "output"
    long_desc Help.text(:output)
    option :out, desc: "path to save the output"
    format_option.call
    def output(mod)
      Commander.new("output", options.merge(mod: mod)).run
    end

    desc "update MODULE", "update infrasturcture. IE: apply plan"
    long_desc Help.text(:update)
    yes_option.call
    option :var_files, type: :array, desc: "list of var files"
    def update(mod)
      Commander.new("apply", options.merge(mod: mod)).run
    end

    desc "validate MODULE", "validate"
    long_desc Help.text(:validate)
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
