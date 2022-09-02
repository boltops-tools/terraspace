class Terraspace::Cloud::Api
  module Methods
    # data: {stream_id:}
    def create_upload(data)
      post("#{stack_path}/uploads", params.merge(data))
    end

    # data: {stream_id:}
    def create_stream(data)
      post("#{stack_path}/streams", params.merge(data))
    end

    # data: {id:, success:}
    def complete_stream(data={})
      post("#{stack_path}/streams/#{data[:id]}/complete", params.merge(data))
    end

    # data: {upload_id: "upload-nRPSpyWd65Ps6978", kind: "apply", stack_id: '...'}
    def create_plan(data)
      post("#{stack_path}/plans", params.merge(data))
    end

    # data: {upload_id: "upload-nRPSpyWd65Ps6978", kind: "apply", stack_id: '...'}
    def create_update(data)
      post("#{stack_path}/updates", params.merge(data))
    end

    # data: {upload_id: "upload-nRPSpyWd65Ps6978", stack_id: '...'}
    def create_cost(data)
      post("#{stack_path}/costs", params.merge(data))
    end

    def get_previous_cost(data)
      get("#{stack_path}/costs/previous", params.merge(data))
    end

    def get_comment(data)
      get("#{stack_path}/comment", params.merge(data))
    end

    # tsc_output("vpc.id", app: nil, role: nil, extra: nil)
    # Example api resp
    # {"vpc_id"=>{"sensitive"=>false, "type"=>"string", "value"=>"vpc_id-value"},
    #  "vpc_id2"=>{"sensitive"=>true, "type"=>"string", "value"=>nil}}
    @@tsc_output_cache = {}
    def tsc_output(identifier, data={})
      mod_name, output = identifier.split('.')
      cloud_stack_name = tsc_output_stack_name(data.merge(mod_name: mod_name))
      logger.debug "tsc_output for cloud_stack_name.output: #{cloud_stack_name}.#{output}"
      stack_outputs_path = stack_path(cloud_stack_name)

      url = "#{stack_outputs_path}/outputs"
      resp = @@tsc_output_cache[url]
      resp ||= get(url)
      @@tsc_output_cache[url] = resp

      # puts "Cloud API: #{stack_outputs_path}"
      # puts "resp: #{resp}"

      output_value = if resp['errors'] && resp.dig('errors',0,'detail') == "Not Found"
        unless ENV['TS_WARN_MISSING_OUTPUT'] == '0'
          logger.info "WARN: tsc_output #{identifier} not found".color(:yellow)
          logger.info "Cloud API: #{stack_outputs_path}"
          call_line = caller.find {|p| p.include?(Terraspace.root) }
          DslEvaluator.print_code(call_line)
        end
        nil
      else
        resp.dig(output, "value") unless resp.dig(output, "sensitive")
      end
      Terraspace::Terraform::RemoteState::OutputProxy.new(@mod, output_value)
    end
  end
end
