class Terraspace::Cloud::Api
  module HttpMethods
    extend Memoist
    include Terraspace::Util

    # Always translate raw json response to ruby Hash
    def request(klass, path, data={})
      exit_on_error = data.delete(:exit_on_error) # for cani logic
      url = url(path)
      check.ok!(cloud: true) unless check.ok?
      data = data.merge(versions: check.versions)
      req = build_request(klass, url, data)
      retries = 0
      begin
        resp = http.request(req) # send request
      rescue Errno::ECONNREFUSED, Errno::EAFNOSUPPORT
        delay = 2 ** retries
        logger.info "Unable to connect to #{url}. Delay for #{delay}s and trying again."
        sleep(delay)
        retries += 1
        # Final retry time: 2 * 4 = 16s
        # Total retry time: 2 ** 4 + 2 ** 3 + 2 ** 2 + 2 ** 1 + 2 ** 0 = 31s
        if retries < 5 # max_retries is 4
          retry
        else
          logger.error "Error connecting to #{url}"
          message = "#{$!.class}: #{$!.message}"
          raise Terraspace::NetworkError.new(message)
        end
      end
      result = load_json(url, resp)
      Cani.new(result).handle(exit_on_error) if data[:cani]
      result
    end

    def build_request(klass, url, data={})
      req = klass.new(url) # url includes query string and uri.path does not, must used url
      set_headers!(req)
      if [Net::HTTP::Delete, Net::HTTP::Patch, Net::HTTP::Post, Net::HTTP::Put].include?(klass)
        text = JSON.dump(data)
        req.body = text
        req.content_length = text.bytesize
      end

      logger.debug "API klass: #{klass}"
      logger.debug "API url: #{url}"
      logger.debug "API data: #{data}"

      req
    end

    def set_headers!(req)
      req['Authorization'] = "Bearer #{token}" if token
      req['Content-Type'] = 'application/json'
    end

    def token
      ENV['TS_TOKEN']
    end

    def load_json(url, resp)
      uri = URI(url)

      logger.debug "resp.code #{resp.code}"
      logger.debug "resp.body #{resp.body}" # {"errors":[{"message":"403 Forbidden"}]}

      if parseable?(resp.code)
        JSON.load(resp.body)
      else
        logger.error "Error: #{url}"
        logger.error "Error: Non-successful http response status code: #{resp.code}"
        # logger.debug "Error: Non-successful http response body: #{resp.body}"
        logger.error "headers: #{resp.each_header.to_h.inspect}"
        logger.error "Terraspace Cloud API #{url}"
        raise "Terraspace Cloud API called failed: #{uri.host}"
      end
    end

    # Note: 422 is Unprocessable Entity. This means an invalid data payload was sent.
    # We want that to error and raise
    def parseable?(http_code)
      http_code =~ /^20/ || http_code =~ /^40/
    end

    def http
      uri = URI(endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = http.read_timeout = 30
      http.use_ssl = true if uri.scheme == 'https'
      http
    end
    memoize :http

    # API does not include the /. IE: https://app.terraform.io/api/v2
    def url(path)
      "#{endpoint}/#{path}"
    end

    def get(path, data={})
      unless data.empty?
        separator = path.include?('?') ? '&' : '?'
        path += separator + data.to_query
      end
      request(Net::HTTP::Get, path)
    end

    def post(path, data={})
      request(Net::HTTP::Post, path, data)
    end

    def put(path, data={})
      request(Net::HTTP::Put, path, data)
    end

    def patch(path, data={})
      request(Net::HTTP::Patch, path, data)
    end

    def delete(path, data={})
      request(Net::HTTP::Delete, path, data)
    end

    def check
      Terraspace::Check.new
    end
    memoize :check
  end
end
