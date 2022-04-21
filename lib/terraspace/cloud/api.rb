module Terraspace::Cloud
  class Api
    include Context
    include HttpMethods

    def initialize(options)
      @options = options
      setup_context(@options)
    end

    def endpoint
      ENV['TS_API'].blank? ? 'https://api.terraspace.cloud/api/v1' : ENV['TS_API']
    end

    def stack_path
      "orgs/#{@org}/projects/#{@project}/stacks/#{@stack}"
    end

    def create_upload
      post("#{stack_path}/uploads", @options)
    end

    # record_attrs: {upload_id: "upload-nRPSpyWd65Ps6978", kind: "apply", stack_id: '...'}
    def create_plan(data)
      post("#{stack_path}/plans", data.merge(@options))
    end

    # data: {upload_id: "upload-nRPSpyWd65Ps6978", kind: "apply", stack_id: '...'}
    def create_update(data)
      post("#{stack_path}/updates", data.merge(@options))
    end
  end
end
