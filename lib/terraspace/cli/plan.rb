class Terraspace::CLI
  class Plan < Base
    include Concerns::PlanPath
    include Terraspace::Cloud::Streamer
    include Terraspace::Cloud::Vcs::Commenter
    include TfcConcern

    def run
      cloud_plan.cani?
      @stream = cloud_stream.open("plan")
      success = perform
      cloud_stream.close(success, @exception)
      exit 1 unless success
    end

    def perform
      success = plan_only
      plan = cloud_plan.create(success, @stream)
      if success && plan # possible from no changes / recording is disabled
        resp = cloud_cost.cani?(exit_on_error: false)
        if resp['errors'] # info on why cannot create a plan from resp
          logger.info "WARN: Not creating a cost estimate."
          logger.info resp['errors'][0]['detail']
        else
          cost = cloud_cost.create(uid: plan['data']['id'], stream: @stream)
          pr_comment(plan, cost)
        end
        logger.info "Terraspace Cloud #{plan['data']['attributes']['url']}"
      end
      success
    rescue Exception => e
      @exception = true
      logger.info "Exception #{e.class}: #{e.message}".color(:red)
      logger.info e.backtrace.join("\n")
      false
    end

    def plan_only
      if Terraspace.cloud? && !@options[:out]
        @options[:out] = plan_path
      end
      cloud_plan.setup
      success = commander.run
      copy_out_file_to_root
      success
    end

    def commander
      Commander.new("plan", @options)
    end
    memoize :commander

    def copy_out_file_to_root
      file = @mod.out_option
      return if !file || @options[:copy_to_root] == false
      return if file =~ %r{^/} # not need to copy absolute path

      name = file.sub("#{Terraspace.root}/",'')
      src = "#{@mod.cache_dir}/#{name}"
      dest = name
      return unless File.exist?(src) # plan wont exists if the plan errors
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp(src, dest)
      !!dest
    end

    def cloud_plan
      Terraspace::Cloud::Plan.new(@options.merge(stack: @mod.name, kind: kind, vcs_vars: vcs_vars))
    end
    memoize :cloud_plan

    def cloud_cost
      Terraspace::Cloud::Cost.new(@options.merge(stack: @mod.name, kind: kind, vcs_vars: vcs_vars))
    end
    memoize :cloud_cost
  end
end
