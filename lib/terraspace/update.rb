module Terraspace
  class Update < AbstractBase
    def run
      Build.new(@options).run # generate and init
      Apply.new(@options).run
    end
  end
end
