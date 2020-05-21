module Terraspace
  module Util
    include Sh

    def pretty_path(path)
      ENV['TS_TEST'] ? path : path.sub("#{Terraspace.root}/",'')
    end

    extend self
  end
end
