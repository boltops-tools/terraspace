require "active_support/lazy_load_hooks"

module Terraspace
  module Layering
    def layers
      pre_layers + main_layers + post_layers
    end

    def main_layers
      # '' prefix for base layer
      [''] + plugins
    end

    def pre_layers
      []
    end

    def post_layers
      []
    end
  end
end

ActiveSupport.run_load_hooks(:terraspace_layering, Terraspace::Layering)
