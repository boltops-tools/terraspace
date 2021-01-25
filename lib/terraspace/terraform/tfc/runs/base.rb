class Terraspace::Terraform::Tfc::Runs
  class Base
    extend Memoist
    include Terraspace::Util::Logging
    include Terraspace::Util::Sure
    include Terraspace::Terraform::Api::Client

    # Api::Client requires @mod to be set
    def initialize(mod, options={})
      @mod, @options = mod, options
    end

    def runs
      runs = api.runs.list
      runs.select! do |item|
        @options[:status].nil? ||
        @options[:status].include?("all") ||
        @options[:status].include?(item['attributes']['status'])
      end
      runs
    end
    memoize :runs

    def build_project
      Terraspace::Builder.new(@options).run

      unless remote && remote['organization']
        logger.info "ERROR: There was no organization found. Are you sure you configured backend.tf with it?".color(:red)
        exit 1
      end
    end
  end
end
