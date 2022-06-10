class Terraspace::CLI
  class Plan < Base
    include TfcConcern
    include Concerns::PlanPath

    def run
      if Terraspace.cloud? && !@options[:out]
        @options[:out] = plan_path
      end
      Commander.new("plan", @options).run
    end
  end
end
