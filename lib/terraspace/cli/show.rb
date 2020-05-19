class Terraspace::CLI
  class Show < Base
    def run
      Terraspace::Builder.new(@options).run # generate and init
      Terraspace::Terraform::Show.new(@options).run
    end
  end
end
