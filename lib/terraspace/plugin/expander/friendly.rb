module Terraspace::Plugin::Expander
  module Friendly
    # used by
    #   Terraspace::Compiler::Strategy::Tfvar::Layer
    #   Terraspace::Plugin::Expander::Interface
    def friendly_name(name)
      Terraspace.config.layering.names[name.to_sym] || name
    end
  end
end
