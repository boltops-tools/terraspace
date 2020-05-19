class Terraspace::CLI
  class Build < Base
    def run
      Terraspace::Builder.new(@options).run
    end
  end
end
