class Terraspace::CLI
  class Down < Base
    include TfcConcern
    include Concerns::PlanPath

    def run
      plan if @options[:yes] && !tfc?
      destroy
    end

  private
    def plan
      if Terraspace.cloud? && !@options[:out]
        @options[:out] = plan_path
      end
      Commander.new("plan", @options.merge(destroy: true)).run
    end

    def destroy
      Commander.new("destroy", @options.merge(command: "down")).run
      Terraspace::Terraform::Tfc::Workspace.new(@options).destroy if @options[:destroy_workspace]
    end
  end
end
