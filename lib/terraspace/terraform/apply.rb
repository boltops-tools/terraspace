module Terraspace::Terraform
  class Apply < Base
    def auto_approve_arg?
      true
    end
  end
end
