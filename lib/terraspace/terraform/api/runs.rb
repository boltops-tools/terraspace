class Terraspace::Terraform::Api
  class Runs < Base
    extend Memoist

    attr_reader :workspace_id
    def initialize(workspace_id)
      @workspace_id = workspace_id
    end

    def list
      payload = http.get("workspaces/#{@workspace_id}/runs")
      payload['data'] if payload
    end

    def discard(id)
      action("discard", id)
    end

    def cancel(id)
      action("cancel", id)
    end

    def action(action, id)
      payload = http.post("runs/#{id}/actions/#{action}")
      payload['data'] if payload
    end
  end
end
