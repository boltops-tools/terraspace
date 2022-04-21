module Terraspace::Cloud
  module Context
    include Terraspace::Cloud::Api::Validate

    def setup_context(options)
      cloud = Terraspace.config.cloud
      @org = cloud.org
      @project = cloud.project
      @stack = options[:stack]
      validate("org", @org)
      validate("project", @project)
    end
  end
end
