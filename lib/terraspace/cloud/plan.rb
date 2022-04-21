module Terraspace::Cloud
  class Plan < Base
    include Terraspace::CLI::Concerns::PlanPath

    def run
      return unless record?

      build
      folder = Folder.new(@options.merge(type: "plan"))
      upload = folder.upload_data # returns upload record
      result = api.create_plan(
        upload_id: upload['id'],
        stack_uid: upload['stack_id'], # use stack_uid since stack_id is friendly url name
        plan: stage_attrs,
      )
      url = terraspace_cloud_info(result)
      pr_comment(url)
    rescue Terraspace::NetworkError => e
      logger.warn "WARN: #{e.class} #{e.message}"
      logger.warn "WARN: Unable to save data to Terraspace cloud"
    end

    def cani?
      api.create_plan(cani: 1)
    end

    def build
      clean_cache2_stage
      # .terraspace-cache/dev/stacks/demo
      Dir.chdir(@mod.cache_dir) do
        plan_dir = File.dirname(plan_path)

        IO.write("#{plan_dir}/plan.log", Terraspace::Logger.logs)

        return unless @success
        return if File.empty?(plan_path)

        out_option_root_path = "#{Terraspace.root}/#{plan_path}"
        return unless File.exist?(out_option_root_path)
        FileUtils.cp(out_option_root_path, plan_path)

        json = plan_path.sub('.binary','.json')
        sh "terraform show -json #{plan_path} > #{json}"
      end
    end
  end
end
