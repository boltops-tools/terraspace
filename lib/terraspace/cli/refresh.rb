class Terraspace::CLI
  class Refresh < Base
    def run
      Terraspace::Builder.new(@options).run # generate and init
      Terraspace::Terraform::Refresh.new(@options).run
    end
  end
end
