# Should implement additional methods that correspond to additional provider specific variables
# available for substitution. For example:
#
#   AWS has :REGION and :ACCOUNT variables.
#   So the aws provider implements the region and account methods.
#
module Terraspace::Plugin::Expander
  module Interface
    include Terraspace::Plugin::InferProvider
    include Terraspace::Plugin::Expander::Friendly

    delegate :build_dir, :type_dir, :type, to: :mod

    attr_reader :mod
    def initialize(mod)
      @mod = mod
    end

    # Handles list of objects. Calls expansion to handle each string expansion.
    def expand(props={})
      props.each do |key, value|
        props[key] = expansion(value)
      end
      props
    end

    # Handles single string
    #
    # Replaces variables denoted by colon in front with actual values. Example:
    #
    #     :REGION/:ENV/:BUILD_DIR/terraform.tfstate
    # =>
    #     us-west-2/dev/stacks/wordpress/terraform.tfstate
    #
    def expansion(string)
      return string unless string.is_a?(String) # in case of nil

      string = string.dup
      vars = string.scan(/:\w+/) # => [":ENV", ":BUILD_DIR"]
      vars.each do |var|
        string.gsub!(var, var_value(var))
      end
      strip(string)
    end

    # remove leading and trailing common separators.
    #
    # This is useful for when INSTANCE is not set.
    # Note: BUILD_DIR includes INSTANCE
    #
    # Examples:
    #
    # cache_dir:
    #
    #    :CACHE_ROOT/:REGION/:ENV/:BUILD_DIR/
    #
    # s3 backend key:
    #
    #    :REGION/:ENV/:BUILD_DIR/terraform.tfstate
    #
    # workspace:
    #
    #    :MOD_NAME-:ENV-:REGION-:INSTANCE
    #
    def strip(string)
      string.sub(/^-+/,'').sub(/-+$/,'') # remove leading and trailing -
            .sub(%r{/+$},'') # only remove trailing / or else /home/ec2-user => home/ec2-user
    end

    def var_value(name)
      name = name.sub(':','').downcase
      value = send(name)
      if name == "namespace" && Terraspace.config.layering.enable_names.expansion
        value = friendly_name(value)
      end
      value
    end

    def mod_name
      @mod.name
    end

    def env
      Terraspace.env
    end

    def type_instance
      [type, instance].reject { |s| s.blank? }.join('-')
    end

    def instance
      @mod.options[:instance] || ''
    end
    alias_method :instance_option, :instance

    def cache_root
      Terraspace.cache_root
    end
  end
end
