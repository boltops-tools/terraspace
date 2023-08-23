module Terraspace::Cloud
  class Cost < Base
    # uid of plan or update
    def create(uid:, stream:)
      return unless Terraspace.cloud?
      return unless Terraspace.config.cloud.cost.enabled

      cani?
      success = build(stream)
      return unless success # in case infracost not installed

      upload = cloud_upload.create(type: "cost", stream_id: stream['data']['id'])
      api.create_cost(
        upload_id: upload['data']['id'],
        stack_uid: upload['data']['attributes']['stack_id'], # use stack_uid since stack_id is friendly url name
        uid: uid,
        cost: cost_attrs,
      )
    rescue Terraspace::NetworkError => e
      logger.warn "WARN: #{e.class} #{e.message}"
      logger.warn "WARN: Unable to save data to Terraspace cloud"
    end

    # different from stage_attrs
    def cost_attrs
      {
        provider: provider.name, # IE: infracost
        provider_version: provider.version,
      }
    end

    def build(stream)
      success = nil
      clean_cache2_stage
      download_previous_cost(stream)
      # .terraspace-cache/dev/stacks/demo
      Dir.chdir(@mod.cache_dir) do
        logger.info "Running cost estimate..."
        success = provider.run
      end
      success
    end

    def download_previous_cost(stream)
      stack_id = stream['data']['attributes']['stack_id'] # stack-SHWx8fW5FbDKg3QK
      cost = api.get_previous_cost(stack_uid: stack_id)
      download_url = cost['data']['attributes']['download_url'] # could be nil
      return unless download_url
      uri = URI(download_url)
      json = Net::HTTP.get(uri) # => JSON String
      dest = "#{@mod.cache_dir}/.terraspace-cache/.cache2/cost/cost_prev.json"
      FileUtils.mkdir_p(File.dirname(dest))
      IO.write(dest, json)
    end

    def provider
      Terraspace::Cloud::Cost::Infracost.new(cloud_stack_name: cloud_stack_name) # only provider currently supported
    end
    memoize :provider

    def cani?(exit_on_error: true)
      return true unless Terraspace.cloud?
      api.create_cost(cani: 1, exit_on_error: exit_on_error)
    end
  end
end
