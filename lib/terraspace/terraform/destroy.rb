module Terraspace::Terraform
  class Destroy < Base
    def auto_approve_arg?
      true
    end
  end
end
