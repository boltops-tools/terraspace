# Should implement additional methods that correspond to additional provider specific variables
# available for substitution. For example:
#
#   AWS has :REGION and :ACCOUNT variables.
#   So the aws provider implements the region and account methods.
#
module Terraspace::Plugin::Expander
  module Interface
    delegate :build_dir, :type_dir, to: :mod

    attr_reader :mod
    def initialize(mod)
      @mod = mod
    end

    def expand(props={})
      props.each do |key, value|
        props[key] = expand_string(value)
      end
      props
    end

    # Replaces variables denoted by colon in front with actual values. Example:
    #
    #     :REGION/:ENV/:BUILD_DIR/terraform.tfstate
    # =>
    #     us-west-2/dev/stacks/wordpress/terraform.tfstate
    #
    def expand_string(string)
      return string unless string.is_a?(String) # in case of nil

      vars = string.scan(/:\w+/) # => [":ENV", ":BUILD_DIR"]
      vars.each do |var|
        string.gsub!(var, var_value(var))
      end
      string
    end

    def var_value(name)
      name = name.sub(':','').downcase
      send(name)
    end

    def mod_name
      @mod.name
    end

    def env
      Terraspace.env
    end
  end
end