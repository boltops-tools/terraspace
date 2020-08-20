require 'net/http'

class Terraspace::Terraform::Api
  class Http
    include Terraspace::Util::Logging

    API = ENV['TERRAFORM_API'] || 'https://app.terraform.io/api/v2'
    extend Memoist

    def get(path)
      request(Net::HTTP::Get, path)
    end

    def post(path, data={})
      request(Net::HTTP::Post, path, data)
    end

    def patch(path, data={})
      request(Net::HTTP::Patch, path, data)
    end

    def delete(path, data={})
      request(Net::HTTP::Delete, path, data)
    end

    # Always translate raw json response to ruby Hash
    def request(klass, path, data={})
      url = url(path)
      http = http(url)
      req = build_request(klass, url, data)
      resp = http.request(req) # send request
      load_json(resp)
    end

    def build_request(klass, url, data={})
      req = klass.new(url) # url includes query string and uri.path does not, must used url
      set_headers!(req)
      if [Net::HTTP::Delete, Net::HTTP::Patch, Net::HTTP::Post, Net::HTTP::Put].include?(klass)
        text = JSON.dump(data)
        req.body = text
        req.content_length = text.bytesize
      end
      req
    end

    def set_headers!(req)
      req['Authorization'] = "Bearer #{token}"
      req['Content-Type'] = "application/vnd.api+json"
    end

    def http(url)
      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = http.read_timeout = 30
      http.use_ssl = true if uri.scheme == 'https'
      http
    end
    memoize :http

    # API does not include the /. IE: https://app.terraform.io/api/v2
    def url(path)
      "#{API}/#{path}"
    end

    def load_json(res)
      if res.code == "200"
        JSON.load(res.body)
      else
        if ENV['TERRASPACE_DEBUG_API']
          puts "Error: Non-successful http response status code: #{res.code}"
          puts "headers: #{res.each_header.to_h.inspect}"
        end
        nil
      end
    end

    def token
      token ||= ENV['TERRAFORM_TOKEN']
      return token if token

      creds_path = "#{ENV['HOME']}/.terraform.d/credentials.tfrc.json"
      if File.exist?(creds_path)
        data = JSON.load(IO.read(creds_path))
        token = data.dig('credentials', 'app.terraform.io', 'token')
      end

      # Note only way to get here is to bypass init. Example:
      #
      #     terraspace up demo --no-init
      #
      unless token
        logger.error "ERROR: Unable to not find a Terraform token. A Terraform token is needed for Terraspace to call the Terraform API.".color(:red)
        logger.error <<~EOL
          Here are some ways to provide the Terraform token:

              1. By running: terraform login
              2. With an env variable: export TERRAFORM_TOKEN=xxx

          Please configure a Terraform token and try again.
        EOL
        exit 1
      end
      token
    end
  end
end
