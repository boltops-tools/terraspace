class Terraspace::Cloud::Api
  module Validate
    def validate_cloud_options(cloud_stack_name)
      validate("stack", cloud_stack_name)
      validate("org", Terraspace.config.cloud.org)
      validate("project", Terraspace.config.cloud.project)
    end

    def validate(name, value)
      unless value =~ /^[\w-]*$/
        message = "ERROR: #{name}: only allows letters, numbers, dashes, and underscores"
      end
      if value =~ /^[-_]/ || value =~ /[-_]$/
        message = "ERROR: #{name}: no leading or trailing underscore or dash allowed"
      end
      if message
        puts message.color(:red)
        puts <<~EOL
          Please fix the configuration

          config/app.rb

             config.cloud.#{name} = '...'

        EOL
        exit 1
      end
    end
  end
end
