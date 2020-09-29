module Terraspace::Dependency::Helper
  class Output < Base
    def result
      if @mod.resolved # dependencies have been resolved
        Terraspace::Terraform::RemoteState::Fetcher.new(@mod, @identifier, @options).output # Returns OutputProxy which defaults to json
      else
        Terraspace::Terraform::RemoteState::Marker::Output.new(@mod, @identifier, @options).build # Returns OutputProxy is NullObject when unresolved
      end
    end
  end
end
