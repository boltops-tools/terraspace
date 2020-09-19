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
      option :instance, aliases: %w[i], desc: "Instance of stack"
    }
    init_option = Proc.new {
      option :init, type: :boolean, default: true, desc: "Instance of stack"
    }
    reconfigure_option = Proc.new {
      option :reconfigure, type: :boolean, desc: "Add terraform -reconfigure option"
    }

    desc "all SUBCOMMAND", "all subcommands"
    long_desc Help.text(:all)
    subcommand "all", All

    desc "cloud SUBCOMMAND", "cloud subcommands"
    long_desc Help.text(:cloud)
    subcommand "cloud", Cloud

    desc "logs SUBCOMMAND", "logs management subcommands"
    long_desc Help.text(:logs)
    subcommand "logs", Logs

    desc "new SUBCOMMAND", "new subcommands"
    long_desc Help.text(:new)
    subcommand "new", New

    desc "build [STACK]", "build"
    long_desc Help.text(:build)
    option :quiet, type: :boolean, desc: "quiet output"
    instance_option.call
    yes_option.call
    def build(mod="placeholder")
      Terraspace::Builder.new(options.merge(mod: mod)).run # building any stack builds them all
    end

    desc "bundle", "bundle"
    long_desc Help.text(:bundle)
    def bundle(*args)
      Bundle.new(options.merge(args: args)).run
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

    desc "console STACK", "console .terraspace-cache dir"
    long_desc Help.text(:console)
    instance_option.call
    def console(mod)
      Commander.new("console", options.merge(mod: mod)).run
    end

    desc "down STACK", "down"
    long_desc Help.text(:down)
    instance_option.call
    yes_option.call
    reconfigure_option.call
    option :destroy_workspace, type: :boolean, desc: "Also destroy the Cloud workspace. Only applies when using Terraform Cloud remote backend."
    def down(mod)
      Down.new(options.merge(mod: mod)).run
    end

    desc "info STACK", "info"
    long_desc Help.text(:info)
    format_option.call
    instance_option.call
    def info(mod)
      Info.new(options.merge(mod: mod)).run
    end

    desc "init STACK", "init"
    long_desc Help.text(:init)
    instance_option.call
    def init(mod)
      Commander.new("init", options.merge(mod: mod, quiet: false)).run
    end

    desc "list", "list stacks and modules"
    long_desc Help.text(:list)
    option :type, aliases: %w[t], desc: "Type: stack or module. Default all"
    def list
      List.new(options).run
    end

    desc "log [ACTION] [STACK]", "The log command allows you to view multiple logs."
    long_desc Help.text("log")
    option :timestamps, aliases: %w[t], type: :boolean, desc: "Whether or not to show the leading timestamp. Defaults to timestamps for multiple logs, and no timestamp if a single log is specified. Note: In follow mode, timestamp always shown"
    option :follow, aliases: %w[f], type: :boolean, desc: "Follow the log in live tail fashion. Must specify a stack if using this option."
    option :limit, aliases: %w[n], default: 10, type: :numeric, desc: "Number of lines to limit showing. Only applies in no-follow mode."
    option :all, aliases: %w[a], type: :boolean, desc: "All mode turns off the limit. Defaults to all if a single log is specified. Only applies in no-follow mode."
    def log(action=nil, stack=nil)
      Log.new(@options.merge(action: action, stack: stack)).run
    end

    desc "plan STACK", "plan stack"
    long_desc Help.text(:plan)
    auto_option.call
    input_option.call
    instance_option.call
    out_option.call
    reconfigure_option.call
    def plan(mod)
      Commander.new("plan", options.merge(mod: mod)).run
    end

    desc "providers STACK", "providers"
    long_desc Help.text(:providers)
    instance_option.call
    def providers(mod)
      Commander.new("providers", options.merge(mod: mod)).run
    end

    desc "refresh STACK", "refresh"
    long_desc Help.text(:refresh)
    instance_option.call
    def refresh(mod)
      Commander.new("refresh", options.merge(mod: mod)).run
    end

    desc "seed STACK", "seed"
    long_desc Help.text(:seed)
    option :yes, aliases: :y, type: :boolean, desc: "bypass prompts and force overwrite files"
    option :where, desc: "where to create file. either under app or seed folder structure. values: app or stack"
    init_option.call
    instance_option.call
    def seed(mod)
      Seed.new(options.merge(mod: mod)).run
    end

    desc "summary", "Summary of resources"
    long_desc Help.text(:clean)
    option :mod, desc: "Module to build to generate a backend file for discovery. By default the last module is used. Usually, it wont matter."
    init_option.call
    option :short, aliases: %w[s], type: :boolean, desc: "Only show statefiles"
    def summary
      Summary.new(options).run
    end

    desc "show STACK", "show"
    long_desc Help.text(:show)
    instance_option.call
    option :plan, desc: "path to created.plan"
    option :json, type: :boolean, desc: "show plan in json format"
    def show(mod)
      Commander.new("show", options.merge(mod: mod)).run
    end

    desc "test", "test"
    long_desc Help.text(:test)
    def test
      Test.new(options).run
    end

    desc "output STACK", "output"
    long_desc Help.text(:output)
    format_option.call
    instance_option.call
    out_option.call
    def output(mod)
      Commander.new("output", options.merge(mod: mod)).run
    end

    desc "up STACK", "Deploy infrastructure. IE: terraform apply"
    long_desc Help.text(:update)
    auto_option.call
    init_option.call
    input_option.call
    instance_option.call
    yes_option.call
    reconfigure_option.call
    option :plan, desc: "Execution plan that can be used to only execute a pre-determined set of actions."
    option :var_files, type: :array, desc: "list of var files"
    def up(mod)
      Up.new(options.merge(mod: mod)).run
    end

    desc "validate STACK", "validate"
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
