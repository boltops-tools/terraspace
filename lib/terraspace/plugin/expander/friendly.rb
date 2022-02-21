module Terraspace::Plugin::Expander
  module Friendly
    # used by
    #   Terraspace::Compiler::Strategy::Tfvar::Layer
    #   Terraspace::Plugin::Expander::Interface
    def friendly_name(name)
      return '' if name.nil?
      names = Terraspace.config.layering.names.stringify_keys
      names[name.to_s] || name
    end
  end
end
