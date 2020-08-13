module Terraspace::Terraform
  class Api
    extend Memoist
    include Client
    include Terraspace::Util::Logging

    def initialize(mod, remote)
      @mod = mod
      @organization = remote['organization']
      @workspace_name = remote['workspaces']['name']
    end

    # Docs: https://www.terraform.io/docs/cloud/api/workspaces.html
    def set_working_dir
      working_directory = @mod.cache_dir.sub("#{Terraspace.root}/", '')
      return if working_directory == workspace['attributes']['working-directory']

      payload = {
        data: {
          attributes: {
            "working-directory": working_directory
          },
          type: "workspaces"
        }
      }
      http.patch("organizations/#{@organization}/workspaces/#{@workspace_name}", payload)
    end

    def set_env_vars
      Vars.new(@mod, workspace).run
    end

    def workspace(options={})
      payload = http.get("organizations/#{@organization}/workspaces/#{@workspace_name}")
      # Note only way to get here is to bypass init. Example:
      #
      #     terraspace up demo --no-init
      #
      unless payload || options[:exit_on_fail] == false
        logger.error "ERROR: Unable to find the workspace. The workspace may not exist. Or the Terraform token may be invalid. Please double check your Terraform token.".color(:red)
        exit 1
      end
      return unless payload
      payload['data']
    end
    memoize :workspace

    def destroy_workspace
      # resp payload from delete operation is nil
      http.delete("/organizations/#{@organization}/workspaces/#{@workspace_name}")
    end
  end
end
