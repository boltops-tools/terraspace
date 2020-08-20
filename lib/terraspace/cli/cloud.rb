class Terraspace::CLI
  class Cloud < Terraspace::Command
    Workspace = Terraspace::Terraform::Cloud::Workspace

    desc "list", "List workspaces"
    long_desc Help.text("cloud:list")
    def list
      Workspace.new(options).list
    end

    desc "destroy", "Destroy workspace"
    long_desc Help.text("cloud:destroy")
    option :yes, aliases: :y, type: :boolean, desc: "bypass are you sure prompt"
    def destroy(mod)
      Workspace.new(options.merge(mod: mod)).destroy
    end

    desc "setup", "Setup workspace"
    long_desc Help.text("cloud:setup")
    def setup(mod)
      Workspace.new(options.merge(mod: mod)).setup
    end
  end
end
