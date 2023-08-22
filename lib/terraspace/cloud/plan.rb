module Terraspace::Cloud
  class Plan < Base
    include Terraspace::CLI::Concerns::PlanPath

    def setup
      return unless Terraspace.cloud?
      cani?

      return unless @mod.out_option
      return if @mod.out_option =~ %r{^/} # not need to create parent dir for copy with absolute path

      name = @mod.out_option.sub("#{Terraspace.root}/",'')
      dest = "#{@mod.cache_dir}/#{name}"
      FileUtils.mkdir_p(File.dirname(dest))
    end

    def create(success, stream)
      return unless Terraspace.cloud?
      return unless record?
      build(success)
      upload = cloud_upload.create(type: "plan", stream_id: stream['data']['id'])
      puts "=> Creating plan record".color(:green)
      puts "stage_attrs(success) #{stage_attrs(success).inspect}}".color(:purple)
      api.create_plan(
        upload_id: upload['data']['id'],
        stack_uid: upload['data']['attributes']['stack_id'], # use stack_uid since stack_id is friendly url name
        plan: stage_attrs(success),
      )
    rescue Terraspace::NetworkError => e
      logger.warn "WARN: #{e.class} #{e.message}"
      logger.warn "WARN: Unable to save data to Terraspace cloud"
    end

    def create_stream
      return unless Terraspace.cloud?
      api.create_stream("plan")
    rescue Terraspace::NetworkError => e
      logger.warn "WARN: #{e.class} #{e.message}"
      logger.warn "WARN: Unable to save data to Terraspace cloud"
    end

    def build(success)
      clean_cache2_stage
      # .terraspace-cache/dev/stacks/demo
      Dir.chdir(@mod.cache_dir) do
        plan_dir = File.dirname(plan_path)

        IO.write("#{plan_dir}/plan.log", Terraspace::Logger.logs)

        return unless success
        return if File.empty?(plan_path)

        out_option_root_path = "#{Terraspace.root}/#{plan_path}"
        return unless File.exist?(out_option_root_path)
        FileUtils.cp(out_option_root_path, plan_path)

        json = plan_path.sub('.binary','.json')
        sh "terraform show -json #{plan_path} > #{json}"
      end
    end

    def cani?(exit_on_error: true)
      return true unless Terraspace.cloud?
      api.create_plan(cani: 1, exit_on_error: exit_on_error)
    end
  end
end
