class Terraspace::CLI
  class Down < Base
    def run
      Terraspace::Builder.new(@options).run # generate and init
      Terraspace::Terraform::Destroy.new(@options).run
    end
  end
end
