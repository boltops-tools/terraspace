class Terraspace::Cloud::Api
  module Concern
    extend Memoist
    include Errors
    include Record
    include Validate

    def api
      validate("stack", cloud_stack_name)
      @options = @options.merge(
        app: Terraspace.app,
        role: Terraspace.role,
        env: Terraspace.env,
        extra: Terraspace.extra,
        region: region,
        name: cloud_stack_name,
      )
      @options.reject! { |k,v| v.nil? }
      Terraspace::Cloud::Api.new(@options) # @options are CLI options
    end

    def cloud_stack_name
      pattern = Terraspace.config.cloud.stack
      expanded = expander.expansion(pattern) # pattern is a String that contains placeholders for substitutions
      expanded.gsub(%r{-+},'-') # remove double dashes are more. IE: -- -> -
              .sub(/^-+/,'').sub(/-+$/,'') # remove leading and trailing -
    end

    def region
      expander.expansion(":REGION")
    end

    def expander
      Terraspace::Compiler::Expander.autodetect(@mod)
    end
    memoize :expander
  end
end
