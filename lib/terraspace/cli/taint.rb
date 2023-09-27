class Terraspace::CLI
  class Taint < Base
    def run
      commander.run
    end

    def commander
      Commander.new("taint", @options)
    end
    memoize :commander
  end
end
