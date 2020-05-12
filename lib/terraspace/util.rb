module Terraspace
  module Util
    def pretty_path(path)
      path.sub("#{Terraspace.root}/",'')
    end
    extend self
  end
end