class Terraspace::Terraform::Api
  class Var
    extend Memoist
    include Client
    include Terraspace::Util::Logging

    def initialize(workspace, attrs={})
      @workspace, @attrs = workspace, attrs
      @workspace_id = @workspace['id']
    end

    def sync
      exist? ? update : create
    end

    def update
      return unless overwrite?
      logger.debug "Updating Terraform Cloud #{category} variable: #{@attrs['key']}"
      variable_id = variable_id(@attrs['key'])
      payload = payload(variable_id)
      http.patch("workspaces/#{@workspace_id}/vars/#{variable_id}", payload)
    end

    def overwrite?
      cloud = Terraspace.config.cloud
      if @attrs['sensitive']
        cloud.overwrite_sensitive
      else
        cloud.overwrite
      end
    end

    def variable_id(key)
      current_var_resp['id']
    end

    def create
      logger.info "Creating Terraform Cloud #{category} variable: #{@attrs['key']}"
      http.post("workspaces/#{@workspace_id}/vars", payload)
    end

    def payload(id=nil)
      data = {
        type: "vars",
        attributes: @attrs
      }
      data[:id] = id if id
      { data: data }
    end

    def exist?
      !!current_var_resp
    end

    def current_var_resp
      current_vars_resp['data'].find do |item|
        attributes = item['attributes']
        attributes['key'] == @attrs['key'] &&
        attributes['category'] == category
      end
    end

    def category
      @attrs['category'] || 'terraform' # default category when not set is terraform
    end

    @@current_vars_resp = nil
    def current_vars_resp
      @@current_vars_resp ||= http.get("workspaces/#{@workspace_id}/vars")
    end
  end
end
