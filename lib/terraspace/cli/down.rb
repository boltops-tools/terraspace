class Terraspace::CLI
  class Down < Base
    include Concerns::PlanPath
    include Terraspace::Cloud::Streamer
    include Terraspace::Cloud::Vcs::Commenter
    include TfcConcern

    def run
      cloud_update.cani?
      @stream = cloud_stream.open("down")
      success = perform
      cloud_stream.close(success, @exception)
      exit 1 unless success
    end

    def perform
      success = nil
      if Terraspace.config.plan_on_yes && @options[:yes] && !tfc?
        success = plan
      else
        skip_plan = true
      end
      if success or skip_plan
        success = destroy
      end
      success
    rescue Exception => e
      @exception = true
      logger.info "Exception #{e.class}: #{e.message}".color(:red)
      logger.info e.backtrace.join("\n")
      false
    end

  private
    def plan
      if Terraspace.cloud? && !@options[:out]
        @options[:out] = plan_path
      end
      plan = Plan.new(@options.merge(destroy: true))
      plan.plan_only # returns success: true or false
    end

    def destroy
      commander = Commander.new("destroy", @options.merge(command: "down"))
      success = commander.run
      update = cloud_update.create(success, @stream)

      if success && @options[:destroy_workspace]
        Terraspace::Terraform::Tfc::Workspace.new(@options).destroy
      end

      logger.info "Terraspace Cloud #{update['data']['attributes']['url']}" if update
      success
    end

    def cloud_update
      Terraspace::Cloud::Update.new(@options.merge(stack: @mod.name, vcs_vars: vcs_vars))
    end
    memoize :cloud_update
  end
end
