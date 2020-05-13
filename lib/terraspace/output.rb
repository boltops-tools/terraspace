module Terraspace
  class Output < AbstractBase
    def run
      Build.new(@options).run # generate and init
      Terraform::Output.new(@options).run
    end
  end
end
