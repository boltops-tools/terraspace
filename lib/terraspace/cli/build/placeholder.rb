# The placeholder stack is a special stack that is useful in case there are no app/stacks.
# We build a placeholder back just so we have backend.tf to be used to grab info.
# It's useful for the summary command.
module Terraspace::CLI::Build
  class Placeholder
    include Terraspace::Util::Logging

    def initialize(options={})
      @options = options
    end

    # Grab the last module and build that.
    # Assume the backend key has the same prefix
    # Note: Tried building a empty "null" stack but with TFC a null space workspace is created, which is undesired.
    def build
      return if ENV['TS_SUMMARY_BUILD'] == '0'

      mod = @options[:mod]
      if !mod or mod == "placeholder"
        logger.info "Building one of the modules to get backend.tf info"
        mod = find_mod
      end
      Terraspace::Builder.new(@options.merge(mod: mod, init: false)).run # generate and init
      Terraspace::Mod.new(mod, @options) # mod metadata
    end

    # Used by: terraspace build placeholder
    def find_mod
      mod_path = Dir.glob("{app,vendor}/{modules,stacks}/*").last
      unless mod_path
        logger.info <<~EOL
          No modules or stacks found.
          Unable to determine the backend state path without at least one module.
        EOL
        exit 0
      end
      File.basename(mod_path) # mod name
    end
  end
end
