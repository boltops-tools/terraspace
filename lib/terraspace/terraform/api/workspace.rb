class Terraspace::Terraform::Api
  class Workspace < Base
    extend Memoist

    attr_reader :name
    def initialize(mod, organization, name)
      @mod, @organization, @name = mod, organization, name
    end

    # Docs: https://www.terraform.io/docs/cloud/api/workspaces.html
    def set_working_dir
      return if working_directory == details['attributes']['working-directory']

      payload = {
        data: {
          attributes: {
            "working-directory": working_directory
          },
          type: "workspaces"
        }
      }
      http.patch("organizations/#{@organization}/workspaces/#{@name}", payload)
    end

    def working_directory
      cache_dir = @mod.cache_dir.sub("#{Terraspace.root}/", '')
      prefix = Terraspace.config.cloud.working_dir_prefix # prepended to TFC Working Directory
      prefix ? "#{prefix}/#{cache_dir}" : cache_dir
    end

    def set_env_vars
      Vars.new(@mod, details).run
    end

    def details(options={})
      payload = http.get("organizations/#{@organization}/workspaces/#{@name}")
      # Note only way to get here is to bypass init. Example:
      #
      #     terraspace up demo --no-init
      #
      unless payload || options[:exit_on_fail] == false
        logger.error "ERROR: Unable to find the workspace: #{@name}. The workspace may not exist. Or the Terraform token may be invalid. Please double check your Terraform token.".color(:red)
        exit 1
      end
      payload['data'] if payload
    end
    memoize :details

    def destroy
      # response payload from delete operation is nil
      http.delete("/organizations/#{@organization}/workspaces/#{@name}")
    end

    # Docs: https://www.terraform.io/docs/cloud/api/workspaces.html
    def create
      payload = upsert_payload
      http.post("organizations/#{@organization}/workspaces", payload)
    end

    def update
      payload = upsert_payload
      http.patch("organizations/#{@organization}/workspaces/#{@name}", payload)
      self.flush_cache
    end

    def upsert_payload
      {
        data: {
          attributes: attributes,
          type: "workspaces"
        }
      }
    end

    def attributes
      attrs = { name: @name }
      config = Terraspace.config.cloud.workspace.attrs
      attrs.merge!(config)
      # Default: run on all changes since app/modules can affect app/stacks
      if config['vcs-repo'] && config['file-triggers-enabled'].nil?
        attrs['file-triggers-enabled'.to_sym] = false
      end
      token = ENV['TS_CLOUD_OAUTH_TOKEN']
      if config['vcs-repo'] && !config.dig('vcs-repo', 'oauth-token-id') && token
        attrs['vcs-repo'.to_sym]['oauth-token-id'.to_sym] ||= token
      end
      attrs
    end

    def create_or_update
      exist? ? update : create
    end

    def exist?
      !!details(exit_on_fail: false)
    end
  end
end
