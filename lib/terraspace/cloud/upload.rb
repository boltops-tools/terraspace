module Terraspace::Cloud
  class Upload < Base
    def create(data) # data: {stream_id:, type: }
      zip_path = Package.new(@options.merge(data)).build
      upload = create_upload(data)
      upload_project(upload, zip_path)
      upload
    end

  private
    def create_upload(params)
      upload = api.create_upload(params)
      if errors?(upload)
        error_message(upload)
        exit 1 # Consider: raise exception can rescue higher up
      else
        upload
      end
    end

    def upload_project(upload, path, retries=0)
      url = upload['data']['attributes']['url']
      uri = URI.parse(url)
      object_content = IO.read(path)
      sleep 2
      resp = Net::HTTP.start(uri.host) do |http|
        http.send_request(
          'PUT',
          uri.request_uri,
          object_content,
          'content-type' => ''
        )
      end
      return if resp.code =~ /^20/

      log_errors(resp.body, :debug)
      if resp.body.include?('expired')
        if retries >= 10 # 15m * 10 = 150m = 2.5h
          log_errors(resp.body, :info)
          exit 1
        end
        logger.debug("Retrying upload")
        upload = create_upload(upload_id: upload['data']['id'])
        upload_project(upload, path, retries+1)
      end
    end

    def log_errors(body, level=:debug)
      logger.send(level, "ERROR: Uploader uploading code")
      logger.send(level, "resp body #{body}")
    end
  end
end
