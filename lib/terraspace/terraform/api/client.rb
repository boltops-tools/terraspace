class Terraspace::Terraform::Api
  module Client
    extend Memoist
    def remote
      backend["remote"]
    end

    def workspace_name
      remote['workspaces']['name']
    end

    def build
      Terraspace::Builder.new(@options).run
    end
    memoize :build

    # backend may be overridden in classes including this Concern
    def backend
      Terraspace::Terraform::Runner::Backend::Parser.new(@mod).result
    end
    memoize :backend

    # api may be overridden in classes including this Concern
    def api
      return unless backend.dig('remote','workspaces') # in case called by terraspace down demo -y --destroy-workspace with a non-remote backend
      Terraspace::Terraform::Api.new(@mod, remote)
    end
    memoize :api
  end
end
