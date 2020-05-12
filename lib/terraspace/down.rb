module Terraspace
  class Down < AbstractBase
    def run
      Build.new(@options).run # generate and init
      Terraform::Destroy.new(@options).run
    end
  end
end
