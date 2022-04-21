class Terraspace::Cloud::Api
  class Cani
    include Terraspace::Util::Logging

    def initialize(result)
      @result = result
    end

    # {"data":{"attributes":{"detail":"You are authorized to perform this action.","status":200,"title":"Authoriz
    # {"errors":[{"detail":"You are not authorized to perform this action. Double check your token or check with your admin that you have permissions.","status":403,"title":"Forbidden"}]}
    def handle
      yes = false # assume do not have permission
      detail = @result&.dig('data', 'attributes', 'detail')
      if detail&.include?('You are authorized to perform this action')
        yes = true # confirm have permission
      end
      return if yes

      if @result.nil? # 400 Bad Request
        logger.info "ERROR: It doesn't look like TS_TOKEN is valid".color(:red)
      else
        errors = @result.dig('errors')
        detail = errors.first['detail']
        # {"errors":[{"detail":"You are not authorized to perform this action. Double check your token or check with your admin that you have permissions.","status":403,"title":"Forbidden"}]}
        logger.info "ERROR: #{detail}".color(:red)
      end
      exit 1
    end
  end
end
