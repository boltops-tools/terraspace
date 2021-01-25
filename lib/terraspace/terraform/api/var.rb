class Terraspace::Terraform::Api
  class Var
    extend Memoist
    include Http::Concern
    include Terraspace::Util::Logging

    # workspace: details from the api response
    def initialize(workspace, attrs={})
      @workspace, @attrs = workspace, attrs
      @workspace_id = @workspace['id']
    end

    def sync
      exist? ? update : create
    end

    def update
      return unless overwrite?
      updating_message
      variable_id = variable_id(@attrs['key'])
      payload = payload(variable_id)
      http.patch("workspaces/#{@workspace_id}/vars/#{variable_id}", payload)
    end

    def overwrite?
      if @attrs['sensitive']
        vars.overwrite_sensitive
      else
        vars.overwrite
      end
    end

    def vars
      Terraspace.config.tfc.vars
    end

    def variable_id(key)
      current_var_resp['id']
    end

    def create
      creating_message
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

    def updating_message
      return unless %w[all update].include?(vars.show_message)
      logger.info "Updating Terraform Cloud #{category} variable: #{@attrs['key']}"
    end

    def creating_message
      return unless %w[all create].include?(vars.show_message)
      logger.info "Creating Terraform Cloud #{category} variable: #{@attrs['key']}"
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
