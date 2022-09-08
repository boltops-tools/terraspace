class Terraspace::CLI
  class Import < Base
    def run
      commander.run
    end

    def commander
      Commander.new("import", @options)
    end
    memoize :commander
  end
end
