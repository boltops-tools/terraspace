module Terraspace::Terraform
  class Api
    extend Memoist

    def initialize(mod, remote)
      @mod, @remote = mod, remote
    end

    def workspace
      Workspace.new(@mod, @remote['organization'], @remote['workspaces']['name'])
    end
    memoize :workspace

    def runs
      workspace_id = workspace.details['id']
      Runs.new(workspace_id)
    end
    memoize :runs
  end
end
