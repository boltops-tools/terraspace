class Terraspace::CLI
  class Cloud < Terraspace::Command
    Syncer = Terraspace::Terraform::Cloud::Syncer
    Workspace = Terraspace::Terraform::Cloud::Workspace

    yes_option = Proc.new {
      option :yes, aliases: :y, type: :boolean, desc: "bypass are you sure prompt"
    }

    desc "list", "List workspaces"
    long_desc Help.text("cloud:list")
    yes_option.call
    def list
      Workspace.new(options).list
    end

    desc "destroy STACK", "Destroy workspace by specifying the stack"
    long_desc Help.text("cloud:destroy")
    def destroy(mod)
      Workspace.new(options.merge(mod: mod)).destroy
    end

    desc "setup STACK", "Setup workspace"
    long_desc Help.text("cloud:setup")
    def setup(mod)
      Workspace.new(options.merge(mod: mod)).setup
    end

    desc "sync [STACK]", "sync workspace"
    long_desc Help.text("cloud:sync")
    yes_option.call
    def sync(mod=nil)
      Syncer.new(options.merge(mod: mod, override_auto_sync: true)).run
    end

    desc "runs SUBCOMMAND", "runs subcommands"
    long_desc Help.text(:runs)
    subcommand "runs", Runs
  end
end
