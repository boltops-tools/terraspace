class Terraspace::CLI
  class Up < Base
    include Concerns::PlanPath
    include Terraspace::Cloud::Streamer
    include Terraspace::Cloud::Vcs::Commenter
    include TfcConcern

    def run
      cloud_update.cani?
      @stream = cloud_stream.open("up")
      success = perform
      create_cloud_records(success)
      cloud_stream.close(success, @exception)
      exit 1 unless success
    end

    def perform
      success = nil
      build
      if Terraspace.config.plan_on_yes && @options[:yes] && !@options[:plan] && !tfc?
        success = plan
      else
        skip_plan = true
      end
      if success or skip_plan
        success = apply
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
      if Terraspace.cloud? && !@options[:plan]
        @options[:plan] = plan_path # for terraform apply
        @options[:out] = plan_path  # for terraform plan
      end

      plan = Plan.new(@options)
      plan.plan_only # returns success: true or false
    end

    def apply
      commander = Commander.new("apply", @options)
      commander.run
    end

    def create_cloud_records(success)
      update = cloud_update.create(success, @stream)
      return unless success && update # possible from no changes / recording is disabled

      resp = cloud_cost.cani?(exit_on_error: false)
      if resp['errors'] # info on why cannot create a plan from resp
        logger.info "WARN: Not creating a cost estimate."
        logger.info resp['errors'][0]['detail']
      else
        cost = cloud_cost.create(uid: update['data']['id'], stream: @stream)
        pr_comment(update, cost)
      end

      logger.info "Terraspace Cloud #{update['data']['attributes']['url']}" if update
    end

    def cloud_update
      Terraspace::Cloud::Update.new(@options.merge(stack: @mod.name, vcs_vars: vcs_vars))
    end
    memoize :cloud_update

    def cloud_cost
      Terraspace::Cloud::Cost.new(@options.merge(stack: @mod.name, vcs_vars: vcs_vars))
    end
    memoize :cloud_cost

    # must build to compute tfc?
    def build
      Terraspace::Builder.new(@options).run
      @options[:build] = false
    end
  end
end
