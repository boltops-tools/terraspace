module Terraspace::Util
  module Sh
    include Terraspace::Util::Logging

    # requires @mod to be set
    def sh(command, options={})
      exit_on_fail = options[:exit_on_fail].nil? ? true : options[:exit_on_fail]
      env = options[:env] || {}
      env.stringify_keys!

      logger.info "=> #{command}"
      return if ENV['TS_TEST']

      success = system(env, command, chdir: @mod.cache_build_dir)
      unless success
        logger.info "Error running command: #{command}".color(:red)
        exit $?.exitstatus if exit_on_fail
      end
    end
  end
end
