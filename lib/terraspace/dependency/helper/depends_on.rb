module Terraspace::Dependency::Helper
  class DependsOn < Base
    def result
      if @mod.resolved # dependencies have been resolved
        # Note: A generated line is not really needed. Dependencies are stored in memory. Added to assist users with debugging
        "# #{@mod.name} depends on #{@identifier}" # raw String value
      else
        Terraspace::Terraform::RemoteState::Marker::Output.new(@mod, @identifier, @options).build # Returns OutputProxy which defaults to json
      end
    end
  end
end
