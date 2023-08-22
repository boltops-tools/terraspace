module Terraspace::Cloud
  class Update < Base
    def create(success, stream)
      return unless Terraspace.cloud?
      return unless record?

      build(success)
      upload = cloud_upload.create(type: "update", stream_id: stream['data']['id'])
      params = {
        upload_id: upload['data']['id'],
        stack_uid: upload['data']['attributes']['stack_id'], # use stack_uid since stack_id is friendly url name
        update: stage_attrs(success),
      }
      api.create_update(params)
    end

    def build(success)
      clean_cache2_stage
      # .terraspace-cache/dev/stacks/demo
      Dir.chdir(@mod.cache_dir) do
        cache2_path = ".terraspace-cache/.cache2/update"
        FileUtils.mkdir_p(cache2_path)

        IO.write("#{cache2_path}/update.log", Terraspace::Logger.logs)
        return unless success

        sh "#{Terraspace.terraform_bin} state pull > #{cache2_path}/state.json"
        sh "#{Terraspace.terraform_bin} output -json > #{cache2_path}/output.json"
      end
    end

    def cani?(exit_on_error: true)
      return true unless Terraspace.cloud?
      api.create_update(cani: 1, exit_on_error: exit_on_error)
    end
  end
end
