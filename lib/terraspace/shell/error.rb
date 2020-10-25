class Terraspace::Shell
  class Error
    attr_accessor :lines
    def initialize
      @lines = '' # holds aggregation of all error lines
    end

    def known?
      !!instance
    end

    def instance
      if reinit_required?
        Terraspace::InitRequiredError.new(@lines)
      elsif bucket_not_found?
        Terraspace::BucketNotFound.new(@lines)
      elsif shared_cache_error?
        Terraspace::SharedCacheError.new(@lines)
      end
    end

    def bucket_not_found?
      # Message is included in aws, azurerm, and google. See: https://bit.ly/3iOKDri
      message.include?("Failed to get existing workspaces")
    end

    def reinit_required?
      # Example error: https://gist.github.com/tongueroo/f7e0a44b64f0a2e533089b18f331c21e
      general_check = message.include?("terraform init") && message.include?("Error:")
      general_check ||
      message.include?("reinitialization required") ||
      message.include?("terraform init") ||
      message.include?("require reinitialization")
    end

    def message
      @lines.gsub("\n", ' ').squeeze(' ') # remove double whitespaces and newlines
    end

    def shared_cache_error?
      # Example: https://gist.github.com/tongueroo/4f2c925709d21f5810229ce9ca482560
      message.include?("Failed to install provider from shared cache") ||
      message.include?("Failed to validate installed provider")
    end
  end
end
