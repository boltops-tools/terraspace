module Terraspace::Cloud
  class Stream < Base
    def open(command)
      return unless Terraspace.cloud?
      @command = command # down, up, plan
      @stream = create_stream
      logger.info "Live Stream: #{@stream['data']['attributes']['url']}"
      @stream_thread ||= Thread.new do
        loop do
          upload_stream
          create_cloud_record
          break if @end_streaming
          sleep 1
        end
      end
      @stream
    end

    def create_cloud_record
      return if @created
      # Dont create records unless changes are detected or user configure to always create recrods
      return unless record_all? || yes? || changes?

      case @command
      when "plan"
        create_plan
      when "up", "down"
        create_update
      end
      @created = true
    end

    def record_all?
      Terraspace.config.cloud.record == "all"
    end

    # Notes: https://gist.github.com/tongueroo/12ca3bec3043fce5e9b52b8580da6b6c
    def changes?
      buffer = Terraspace::Logger.buffer.map { |s| s.force_encoding('UTF-8') }
      will_found = buffer.detect { |s| s.include?("Terraform will perform") }
      saved_found = buffer.detect { |s| s.include?("Saved the plan to:") }
      !!(will_found && saved_found)
    end

    def yes?
      Terraspace::Logger.stdin_capture == 'yes'
    end

    def create_plan
      api.create_plan(
        stream_id: @stream['data']['id'],
        plan: stage_attrs(nil),
      )
    end

    def create_update
      api.create_update(
        stream_id: @stream['data']['id'],
        update: stage_attrs(nil),
      )
    end

    def close(success, exception)
      return unless @stream
      @end_streaming = true
      @stream_thread.join
      status = success ? "success" : "fail"
      api.complete_stream(id: @stream['data']['id'], status: status, exception: !!exception)
    end

    def upload_stream(retries=0)
      stream_url = @stream['data']['attributes']['upload_url']
      url = stream_url
      uri = URI.parse(url)
      object_content = Terraspace::Logger.logs
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
        if retries >= 10 # 15m * 10 = 150m = 2.5h TODO: CHANGE
          log_errors(resp.body, :info)
          # raise "RetriesExceeded"
          exit 1
        end
        logger.debug("Retrying upload")
        @stream = create_stream(stream_id: @stream['data']['id'])
        upload_stream(retries+1)
      end
    end

    def create_stream(params={})
      api.create_stream(params.merge(command: @command))
    rescue Terraspace::NetworkError => e
      logger.warn "WARN: Error calling Terraspace cloud"
      logger.warn "WARN: #{e.class} #{e.message}"
    end

    def log_errors(body, level=:debug)
      logger.send(level, "ERROR: Stream uploading logs")
      logger.send(level, "resp body #{body}")
    end

  end
end
