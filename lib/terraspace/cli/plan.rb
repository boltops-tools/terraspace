class Terraspace::CLI
  class Plan < Base
    def run
      Terraspace::Builder.new(@options).run # generate and init
      Terraspace::Terraform::Plan.new(@options).run
    end
  end
end
