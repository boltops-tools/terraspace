module Terraspace::Cloud
  class Api
    extend Memoist
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

    # data: {stream_id:}
    def create_upload(data)
      post("#{stack_path}/uploads", @options.merge(data))
    end

    # data: {stream_id:}
    def create_stream(data)
      post("#{stack_path}/streams", @options.merge(data))
    end

    # data: {id:, success:}
    def complete_stream(data={})
      post("#{stack_path}/streams/#{data[:id]}/complete", @options.merge(data))
    end

    # data: {upload_id: "upload-nRPSpyWd65Ps6978", kind: "apply", stack_id: '...'}
    def create_plan(data)
      post("#{stack_path}/plans", @options.merge(data))
    end

    # data: {upload_id: "upload-nRPSpyWd65Ps6978", kind: "apply", stack_id: '...'}
    def create_update(data)
      post("#{stack_path}/updates", @options.merge(data))
    end

    # data: {upload_id: "upload-nRPSpyWd65Ps6978", stack_id: '...'}
    def create_cost(data)
      post("#{stack_path}/costs", @options.merge(data))
    end

    def get_previous_cost(data)
      get("#{stack_path}/costs/previous", @options.merge(data))
    end

    def get_comment(data)
      get("#{stack_path}/comment", @options.merge(data))
    end
  end
end
