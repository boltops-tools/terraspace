module Terraspace::Terraform::Cloud
  class Sync < Terraspace::CLI::Base
    extend Memoist
    include Terraspace::Terraform::Api::Client

    # Note about why workspace.create is called:
    #
    # CLI::Init#run
    #   init => runs `terraform init`
    #   build_remote_dependencies
    #   sync_cloud => leads to create_workspace
    #
    # The `terraform init` will auto-create the TFC workspace
    # If there is a .terraform folder the config.init.mode == "auto" though,
    # then the workspace won't be created.
    # So we check and create the workspace if necessary.
    def run
      # Note: workspace still gets created by `terraform init` However, variables wont be sync if returns early
      return unless Terraspace.config.cloud.auto_sync || @options[:override_auto_sync]
      return unless workspaces_backend?
      logger.info "Syncing to Terraform Cloud: #{@mod.name} => #{workspace_name}"
      @api = Terraspace::Terraform::Api.new(@mod, remote)
      workspace.create_or_update
      workspace.set_working_dir
      workspace.set_env_vars
    end

    def workspace
      @api.workspace
    end

    def workspaces_backend?
      remote && remote['workspaces']
    end

    # already memoized in Api::Client
    def backend
      Terraspace::Compiler::Backend::Parser.new(@mod).result
    end
  end
end
