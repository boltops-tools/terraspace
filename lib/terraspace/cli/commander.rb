class Terraspace::CLI
  class Commander < Base
    def initialize(name, options={})
      @name = name
      super(options)
    end

    def run
      Build.new(@options).run # generate and init

      terraform = terraform_class.new(@options) # IE: Terraspace::Terraform::Plan
      terraform.run
    end

    def terraform_class
      "Terraspace::Terraform::#{@name.camelize}".constantize
    end
  end
end
