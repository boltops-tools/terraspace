class Terraspace::Terraform::Api
  class Token
    include Terraspace::Util::Logging

    attr_reader :token
    def initialize
      @creds_path = "#{ENV['HOME']}/.terraform.d/credentials.tfrc.json"
      @hostname = hostname
    end

    def get
      @token = ENV['TERRAFORM_TOKEN']
      return @token if @token
      @token = load
      return @token if @token
      error_exit!
    end

    def load
      return unless File.exist?(@creds_path)

      data = JSON.load(IO.read(@creds_path))
      @token = data.dig('credentials', @hostname, 'token')
      return @token if @token

      return unless hostname_configured?
      logger.error "You configured a cloud.hostname: #{@hostname}".color(:red)
      logger.error <<~EOL
        But it was not found into your #{@creds_path}
        Please double check it.
      EOL
      @token
    end

    # Internal note only way to get here is to bypass init. Example:
    #
    #     terraspace up demo --no-init
    #
    def error_exit!
      login_hostname = @hostname if hostname_configured?
      logger.error "ERROR: Unable to not find a Terraform token. A Terraform token is needed for Terraspace to call the Terraform API.".color(:red)
      logger.error <<~EOL
        Here are some ways to provide the Terraform token:

            1. By running: terraform login #{login_hostname}
            2. With an env variable: export TERRAFORM_TOKEN=xxx

        Please configure a Terraform token and try again.
      EOL
      exit 1
    end

    def hostname
      ENV['TFC_HOST'] || Terraspace.config.tfc.hostname || 'app.terraform.io'
    end

    def hostname_configured?
      !!Terraspace.config.tfc.hostname
    end

    def self.get
      new.get
    end
  end
end
