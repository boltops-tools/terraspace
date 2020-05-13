module Terraspace::Terraform
  class Init < Base
    def run
      # return if dot_terraform_exist? # TODO: make smarter
      terraform(name, args) unless ENV['TS_SKIP_INIT']
    end

    # scoped to this command only
    def scoped_args
      "-get"
    end

    def dot_terraform_exist?
      File.exist?("#{@mod.cache_build_dir}/.terraform")
    end
  end
end
