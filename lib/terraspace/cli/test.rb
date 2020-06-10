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
      command = adjust_command(command)
      puts "=> #{command}"
      Kernel.exec(command)
    end

    def adjust_command(command)
      if cd_into_test?
        command = "bundle exec #{command}" unless command.include?("bundle exec")
        command = "cd test && #{command}"
      else
        command
      end
    end

    # Automatically cd into the test folder in case running within the root of a module.
    # Detect/guess that we're in a module folder vs the terraspace project
    def cd_into_test?
      !File.exist?("app") && File.exist?("test") &&
      (File.exist?("main.tf") || File.exist?("main.rb"))
    end
  end
end
