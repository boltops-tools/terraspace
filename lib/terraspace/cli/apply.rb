class Terraspace::CLI
  class Apply < Base
    def run
      Terraspace::Terraform::Apply.new(@options).run
    end
  end
end
