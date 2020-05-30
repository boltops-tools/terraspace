class Terraspace::CLI
  class Test
    def initialize(options={})
      @options = options
    end

    def run
      config = Terraspace.config
      test_command = config.test_framework_command || config.test_framework
      execute(test_command)
    end

    def execute(command)
      puts "=> #{command}"
      Kernel.exec(command)
    end
  end
end
