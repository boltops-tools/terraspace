module Terraspace
  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    base_options = Proc.new {
      option :yes, aliases: :y, type: :boolean, desc: "-auto-approve the terraform apply"
    }

    desc "new SUBCOMMAND", "new subcommands"
    long_desc Help.text(:new)
    subcommand "new", New

    desc "update MODULE", "update infrasturcture. IE: apply plan"
    long_desc Help.text(:update)
    base_options.call
    def update(mod)
      Update.new(options.merge(mod: mod)).run
    end

    desc "down MODULE", "down"
    long_desc Help.text(:down)
    base_options.call
    def down(mod)
      Down.new(options.merge(mod: mod)).run
    end

    desc "plan MODULE", "plan module"
    long_desc Help.text(:plan)
    def plan(mod)
      Plan.new(options.merge(mod: mod)).run
    end

    desc "build MODULE", "build"
    long_desc Help.text(:build)
    def build(mod)
      Build.new(options.merge(mod: mod)).run
    end

    desc "output MODULE", "output"
    long_desc Help.text(:output)
    def output(mod)
      Output.new(options.merge(mod: mod)).run
    end

    desc "clean", "clean .terraspace-cache dir"
    long_desc Help.text(:clean)
    def clean
      Clean.new(options).run
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
