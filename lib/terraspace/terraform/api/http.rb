require 'net/http'

class Terraspace::Terraform::Api
  class Http
    API = ENV['TERRAFORM_API'] || 'https://app.terraform.io/api/v2'

    extend Memoist
    include Terraspace::Util::Logging

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
      if ok?(res.code)
        JSON.load(res.body)
      else
        logger.info "Error: Non-successful http response status code: #{res.code}"
        logger.info "headers: #{res.each_header.to_h.inspect}"
        raise "TFC API called failed"
      end
    end

    # Note: 422 is Unprocessable Entity. This means an invalid data payload was sent.
    # We want that to error and raise
    def ok?(http_code)
      http_code =~ /^20/ ||
      http_code =~ /^40/
    end

    def token
      Token.get
    end
  end
end
