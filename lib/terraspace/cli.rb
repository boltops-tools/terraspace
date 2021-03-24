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
      option :out, aliases: :o, desc: "Write the output to path"
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
    type_option = Proc.new {
      option :type, default: "stack", aliases: %w[t], desc: "Type: stack, module, or all"
    }

    desc "all SUBCOMMAND", "all subcommands"
    long_desc Help.text(:all)
    subcommand "all", All

    desc "clean SUBCOMMAND", "clean subcommands"
    long_desc Help.text(:clean)
    subcommand "clean", Clean

    desc "new SUBCOMMAND", "new subcommands"
    long_desc Help.text(:new)
    subcommand "new", New

    desc "tfc SUBCOMMAND", "tfc subcommands"
    long_desc Help.text(:tfc)
    subcommand "tfc", Tfc

    desc "build [STACK]", "Build project."
    long_desc Help.text(:build)
    option :quiet, type: :boolean, desc: "quiet output"
    instance_option.call
    yes_option.call
    def build(mod="placeholder")
      Terraspace::Builder.new(options.merge(mod: mod)).run # building any stack builds them all
    end

    desc "bundle", "Bundle with Terrafile."
    long_desc Help.text(:bundle)
    def bundle(*args)
      Bundle.new(options.merge(args: args)).run
    end

    desc "check_setup", "Check setup."
    long_desc Help.text(:check_setup)
    def check_setup
      CheckSetup.new(options).run
    end

    desc "console STACK", "Run console in built terraform project."
    long_desc Help.text(:console)
    instance_option.call
    def console(mod)
      Commander.new("console", options.merge(mod: mod, shell: "system")).run
    end

    desc "down STACK", "Destroy infrastructure stack."
    long_desc Help.text(:down)
    instance_option.call
    yes_option.call
    reconfigure_option.call
    option :destroy_workspace, type: :boolean, desc: "Also destroy the Cloud workspace. Only applies when using Terraform Cloud remote backend."
    def down(mod)
      Down.new(options.merge(mod: mod)).run
    end

    desc "fmt", "Run terraform fmt"
    long_desc Help.text(:fmt)
    type_option.call
    def fmt(mod=nil)
      Fmt.new(options.merge(mod: mod)).run
    end

    desc "info STACK", "Get info about stack."
    long_desc Help.text(:info)
    instance_option.call
    option :format, desc: "Output formats: #{CliFormat.formats.join(', ')}"
    option :path, desc: "Print path to built path"
    def info(mod)
      Info.new(options.merge(mod: mod)).run
    end

    desc "init STACK", "Run init in built terraform project."
    long_desc Help.text(:init)
    instance_option.call
    def init(mod)
      Commander.new("init", options.merge(mod: mod, quiet: false)).run
    end

    desc "list", "List stacks and modules."
    long_desc Help.text(:list)
    type_option.call
    def list
      List.new(options).run
    end

    desc "logs [ACTION] [STACK]", "View and tail logs."
    long_desc Help.text("logs")
    option :timestamps, aliases: %w[t], type: :boolean, desc: "Whether or not to show the leading timestamp. Defaults to timestamps for multiple logs, and no timestamp if a single log is specified. Note: In follow mode, timestamp always shown"
    option :follow, aliases: %w[f], type: :boolean, desc: "Follow the log in live tail fashion. Must specify a stack if using this option."
    option :limit, aliases: %w[n], default: 10, type: :numeric, desc: "Number of lines to limit showing. Only applies in no-follow mode."
    option :all, aliases: %w[a], type: :boolean, desc: "All mode turns off the limit. Defaults to all if a single log is specified. Only applies in no-follow mode."
    option :pid, aliases: %w[p], desc: "Filter by pid. Defaults to the last pid at the bottom of the log file."
    def logs(action=nil, stack=nil)
      Logs.new(@options.merge(action: action, stack: stack)).run
    end

    desc "plan STACK", "Plan stack."
    long_desc Help.text(:plan)
    auto_option.call
    input_option.call
    instance_option.call
    out_option.call
    reconfigure_option.call
    option :copy_to_root, type: :boolean, default: true, desc: "Copy plan file generated in the cache folder back to project root"
    def plan(mod)
      Commander.new("plan", options.merge(mod: mod)).run
    end

    desc "providers STACK", "Show providers."
    long_desc Help.text(:providers)
    instance_option.call
    def providers(mod)
      Commander.new("providers", options.merge(mod: mod)).run
    end

    desc "refresh STACK", "Run refresh."
    long_desc Help.text(:refresh)
    instance_option.call
    def refresh(mod)
      Commander.new("refresh", options.merge(mod: mod)).run
    end

    desc "seed STACK", "Build starer seed tfvars file."
    long_desc Help.text(:seed)
    option :yes, aliases: :y, type: :boolean, desc: "bypass prompts and force overwrite files"
    option :where, desc: "where to create file. either under app or seed folder structure. values: seed or stack"
    init_option.call
    instance_option.call
    def seed(mod)
      Seed.new(options.merge(mod: mod)).run
    end

    desc "summary", "Summarize resources."
    long_desc Help.text(:summary)
    option :mod, desc: "Module to build to generate a backend file for discovery. By default the last module is used. Usually, it wont matter."
    init_option.call
    option :details, type: :boolean, desc: "Show details of the listed resources"
    def summary
      Summary.new(options).run
    end

    desc "show STACK", "Run show."
    long_desc Help.text(:show)
    instance_option.call
    option :plan, desc: "path to created.plan"
    option :json, type: :boolean, desc: "show plan in json format"
    def show(mod)
      Commander.new("show", options.merge(mod: mod)).run
    end

    desc "state SUBCOMMAND STACK", "Run state."
    long_desc Help.text(:state)
    def state(subcommand, mod)
      State.new(options.merge(subcommand: subcommand, mod: mod)).run
    end

    desc "test", "Run test."
    long_desc Help.text(:test)
    def test
      Test.new(options).run
    end

    desc "output STACK", "Run output."
    long_desc Help.text(:output)
    format_option.call
    instance_option.call
    out_option.call
    def output(mod)
      Commander.new("output", options.merge(mod: mod)).run
    end

    desc "up STACK", "Deploy infrastructure stack."
    long_desc Help.text(:up)
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

    desc "validate STACK", "Validate stack."
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

    desc "version", "Prints version."
    def version
      puts VERSION
    end
  end
end
