class Terraspace::CLI
  class Untaint < Base
    def run
      commander.run
    end

    def commander
      Commander.new("untaint", @options)
    end
    memoize :commander
  end
end
