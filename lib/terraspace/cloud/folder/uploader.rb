class Terraspace::Cloud::Folder
  class Uploader < Base
    attr_reader :record
    def upload
      @record = create_record # set @record for start_plan(uploader.record)
      upload_project(@record['url'], zip_path)
    end

    def create_record
      result = api.create_upload
      if errors?(result)
        error_message(result)
        exit 1 # Consider: raise exception can rescue higher up
      else
        load_record(result)
      end
    end

    def upload_project(url, path)
      uri = URI.parse(url)
      object_content = IO.read(path)
      resp = Net::HTTP.start(uri.host) do |http|
        http.send_request(
          'PUT',
          uri.request_uri,
          object_content,
          'content-type' => ''
        )
      end
      unless resp.code =~ /^20/
        puts "ERROR: Uploading code"
        puts "resp.body #{resp.body}"
        exit 1 # TODO: consider raising error
      end
    end
  end
end
