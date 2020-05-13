class Terraspace::Compiler::State
  class Base
    delegate :build_dir, :type_dir, to: :mod

    attr_reader :mod
    def initialize(mod)
      @mod = mod
    end

    def expand(props={})
      props[:prefix] = expand_string(props[:prefix]) if props[:prefix]
      props[:key] = expand_string(props[:key]) if props[:key]
      props
    end

    # Replaces variables denoted by colon in front with actual values. Example:
    #
    #     :account/:region/:env/:build_dir/terraform.tfstate
    # =>
    #     112233445566/us-west-2/development/stacks/wordpress/terraform.tfstate
    #
    def expand_string(string)
      return unless string # in case of nil

      vars = string.scan(/:\w+/) # => [":env", ":build_dir"]
      vars.each do |var|
        string.gsub!(var, var_value(var))
      end
      string
    end

    def var_value(name)
      name = name.sub(':','')
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
