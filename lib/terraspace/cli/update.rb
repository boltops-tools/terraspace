class Terraspace::CLI
  class Update < Base
    def run
      Terraspace::Builder.new(@options).run # generate and init
      Apply.new(@options).run
    end
  end
end
