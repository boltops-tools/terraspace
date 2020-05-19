class Terraspace::CLI
  class Output < Base
    def run
      Terraspace::Builder.new(@options).run # generate and init
      Terraspace::Terraform::Output.new(@options).run
    end
  end
end
