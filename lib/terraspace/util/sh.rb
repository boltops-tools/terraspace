module Terraspace::Util
  module Sh
    # requires @mod to be set
    def sh(command, exit_on_fail: true)
      puts "=> #{command}"

      Dir.chdir(@mod.cache_build_dir) do
        success = system(command)
        unless success
          puts "Error running command: #{command}".color(:red)
          exit $?.exitstatus if exit_on_fail
        end
      end
    end
  end
end
