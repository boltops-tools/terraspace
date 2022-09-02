module Terraspace::Cloud
  class Api
    extend Memoist
    include HttpMethods
    include Validate
    include Methods

    def initialize(options={})
      @mod = options[:mod] || raise("@mod is required to be set")
      @options = options
    end

    def params
      validate_cloud_options(cloud_stack_name)
      params = @options.merge(
        app: Terraspace.app,
        role: Terraspace.role,
        env: Terraspace.env,
        extra: Terraspace.extra,
        region: region,
        name: cloud_stack_name,
      )
      params.reject! { |k,v| v.nil? }
      params
    end

    def region
      expander.expansion(":REGION")
    end

    def expander
      Terraspace::Compiler::Expander.autodetect(@mod)
    end
    memoize :expander

    def endpoint
      ENV['TS_API'].blank? ? 'https://api.terraspace.cloud/api/v1' : ENV['TS_API']
    end

    def stack_path(stack=nil)
      stack ||= @options[:stack]
      cloud = Terraspace.config.cloud
      "orgs/#{cloud.org}/projects/#{cloud.project}/stacks/#{stack}"
    end

    # config.cloud.stack pattern default: :APP-:ROLE-:MOD_NAME-:ENV-:EXTRA-:REGION
    def tsc_output_stack_name(options={})
      # Default behavior is to assign these vars conventionally: env, mod_name, region
      # Other vars must be explicitly set: app, role, extra
      options[:env] ||= Terraspace.env
      options[:mod_name] ||= @mod.name
      options[:region] ||= region

      pattern = Terraspace.config.cloud.stack.dup
      vars = pattern.scan(/:\w+/) # [":APP", ":ROLE", ":MOD_NAME", ":ENV", ":EXTRA", ":REGION"]
      vars.each do |var|
        key = var.sub(':','').downcase.to_sym
        val = options[key]
        if val
          pattern.sub!(var, val.to_s)
        else
          pattern.sub!(var, '')
        end
      end
      expand(pattern)
    end

    def cloud_stack_name
      expand(Terraspace.config.cloud.stack.dup)
    end

    def expand(pattern)
      expanded = expander.expansion(pattern) # pattern is a String that contains placeholders for substitutions
      expanded.gsub(%r{-+},'-') # remove double dashes are more. IE: -- -> -
              .sub(/^-+/,'').sub(/-+$/,'') # remove leading and trailing -
    end
  end
end
