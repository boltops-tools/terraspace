module Terraspace::Cloud
  class Folder < Base
    def upload_data
      Package.new(@options).build
      uploader = Uploader.new(@options)
      uploader.upload
      @upload = uploader.record
    end
    attr_reader :upload # upload record
  end
end
