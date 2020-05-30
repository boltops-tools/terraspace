# Should implement call method
module Terraspace::Provider::Decorator
  module Interface
    def initialize(type, props={})
      @type, @props = type, props
    end
  end
end
