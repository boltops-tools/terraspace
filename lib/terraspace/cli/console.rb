class Terraspace::CLI
  class Console < Base
    def run
      Terraspace::Builder.new(@options).run # generate and init
      Terraspace::Terraform::Console.new(@options).run
    end
  end
end
