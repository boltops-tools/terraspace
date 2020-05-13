module Terraspace::Util
  module Sh
    # requires @mod to be set
    def sh(command, options={})
      exit_on_fail = options[:exit_on_fail].nil? ? true : options[:exit_on_fail]
      env = options[:env] || {}
      env.stringify_keys!

      puts "=> #{command}"

      success = system(env, command, chdir: @mod.cache_build_dir)
      unless success
        puts "Error running command: #{command}".color(:red)
        exit $?.exitstatus if exit_on_fail
      end
    end
  end
end
