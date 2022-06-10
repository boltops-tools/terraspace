require 'securerandom'

class Terraspace::CLI
  class Up < Base
    include TfcConcern
    include Concerns::PlanPath

    def run
      build
      if @options[:yes] && !@options[:plan] && !tfc?
        if Terraspace.cloud? && !@options[:plan]
          @options[:plan] = plan_path # for terraform apply
          @options[:out] = plan_path  # for terraform plan
        end
        Commander.new("plan", @options).run
        return unless File.exist?(plan_path) if Terraspace.cloud? # happens if plan fails
        Commander.new("apply", @options).run
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
  end
end
