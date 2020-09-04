module Terraspace::All
  class Base
    def initialize(options={})
      @options = options
      Terraspace.check_project! unless ENV['TS_TEST']
    end
  end
end
