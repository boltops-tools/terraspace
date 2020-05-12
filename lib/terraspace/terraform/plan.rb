module Terraspace::Terraform
  class Plan < Base
    def run
      terraform(command, args)
    end
  end
end
