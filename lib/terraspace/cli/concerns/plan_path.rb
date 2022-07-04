module Terraspace::CLI::Concerns
  module PlanPath
    # Use when --out option not used
    def plan_path
      ".terraspace-cache/.cache2/plan/plan.binary"
    end
  end
end
