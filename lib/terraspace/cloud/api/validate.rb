class Terraspace::Cloud::Api
  module Validate
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
