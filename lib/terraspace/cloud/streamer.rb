module Terraspace::Cloud
  module Streamer
    extend Memoist
    def cloud_stream
      Terraspace::Cloud::Stream.new(@options.merge(stack: @mod.name, kind: kind, vcs_vars: vcs_vars))
    end
    memoize :cloud_stream
  end
end
