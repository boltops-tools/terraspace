class Terraspace::CLI::Clean
  class Base
    include Terraspace::Util::Logging
    include Terraspace::Util::Sure

    def initialize(options={})
      @options = options
    end

    def pretty(path)
      Terraspace::Util.pretty_path(path)
    end
  end
end
