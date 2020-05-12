module Terraspace
  class Plan < AbstractBase
    def run
      Build.new(@options).run # generate and init
      Terraform::Plan.new(@options).run
    end
  end
end
