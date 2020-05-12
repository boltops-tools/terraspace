module Terraspace::Terraform
  class Destroy < Base
    def run
      terraform(name, args)
    end

    def auto_approve_arg?
      true
    end
  end
end
