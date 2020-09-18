class Terraspace::CLI
  class Up < Base
    include TfcConcern

    def run
      build
      if @options[:yes] && !tfc?
        plan
        Commander.new("apply", @options.merge(plan: plan_path)).run
      else
        Commander.new("apply", @options).run
      end
    end

  private
    # must build to compute tfc?
    def build
      Terraspace::Builder.new(@options).run
      @options[:build] = false
    end

    def plan
      FileUtils.mkdir_p(File.dirname(plan_path))
      Commander.new("plan", @options.merge(out: plan_path)).run
    end

    def plan_path
      @@timestamp ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
      "#{Terraspace.tmp_root}/plans/#{@mod.name}-#{@@timestamp}.plan"
    end
  end
end
