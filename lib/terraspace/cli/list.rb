class Terraspace::CLI
  class List
    def initialize(options={})
      @options = options
    end

    def run
      Dir.glob("{app,vendor}/{modules,stacks}/*").sort.each do |path|
        puts path
      end
    end
  end
end
