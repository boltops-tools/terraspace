module Terraspace
  class Apply < AbstractBase
    def run
      Terraform::Apply.new(@options).run
    end
  end
end
