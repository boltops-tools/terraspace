class Terraspace::CLI
  class Providers < Base
    def run
      Terraspace::Builder.new(@options).run # generate and init
      Terraspace::Terraform::Providers.new(@options).run
    end
  end
end
