# Should implement call method
module Terraspace::Plugin::Decorator
  module Interface
    def initialize(type, props={})
      @type, @props = type, props
    end
  end
end
