module Terraspace::Terraform
  class Cloud < Terraspace::CLI::Base
    extend Memoist

    def run
      return unless workspaces?
      api = Api.new(@mod, remote)
      api.set_working_dir
      api.set_env_vars
    end

    def workspaces?
      remote && remote['workspaces']
    end

    def remote
      backend["remote"]
    end

    def backend
      Terraspace::Compiler::Backend::Parser.new(@mod).result
    end
    memoize :backend
  end
end
