class Terraspace::Terraform::Api
  class Runs < Base
    extend Memoist

    attr_reader :workspace_id
    def initialize(workspace_id)
      @workspace_id = workspace_id
    end

    def list
      data, next_page = [], :start
      while next_page == :start || next_page
        url = "workspaces/#{@workspace_id}/runs"
        if next_page
          qs = URI.encode_www_form('page[number]': next_page) if next_page
          url += "?#{qs}"
        end
        payload = http.get(url)
        return unless payload
        data += payload['data']
        next_page = payload['meta']['pagination']['next-page']
      end
      data
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
