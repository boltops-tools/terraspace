class Terraspace::Cloud::Api
  module Errors
    def errors?(result)
      result.is_a?(Hash) && result.key?("errors")
    end

    def error_message(result)
      $stderr.puts "ERROR: #{result["errors"]}"
      $stderr.puts "Your current settings. org: #{@org} project: #{@project}"
    end
  end
end
