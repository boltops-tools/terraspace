class Terraspace::Builder
  class Allow
    def initialize(mod)
      @mod = mod
    end

    def check!
      messages = []
      unless env_allowed?
        messages << "This env is not allowed to be used: TS_ENV=#{Terraspace.env}"
        messages << "Allowed envs: #{config.allow.envs.join(', ')}"
      end
      unless region_allowed?
        messages << "This region is not allowed to be used: Detected current region=#{current_region}"
        messages << "Allowed regions: #{config.allow.regions.join(', ')}"
      end
      unless messages.empty?
        puts "ERROR: The configs do not allow this.".color(:red)
        puts messages
        exit 1
      end
    end

    def env_allowed?
      return true unless config.allow.envs
      config.allow.envs.include?(Terraspace.env)
    end

    def region_allowed?
      return true unless config.allow.regions
      config.allow.regions.include?(current_region)
    end

    def current_region
      expander = Terraspace::Compiler::Expander.autodetect(@mod).expander
      expander.region
    end

    def config
      Terraspace.config
    end
  end
end
