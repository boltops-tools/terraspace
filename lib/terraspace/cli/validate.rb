class Terraspace::CLI
  class Validate < Base
    def run
      Terraspace::Builder.new(@options).run # generate and init
      Terraspace::Terraform::Validate.new(@options).run
    end
  end
end
