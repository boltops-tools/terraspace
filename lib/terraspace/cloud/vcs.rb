module Terraspace::Cloud
  class Vcs
    class << self
      @@name = nil
      def register(options={})
        @@name = options[:name]
      end

      # IE: TerraspaceVcsGithub::Interface.new
      def detect(options)
        name = detect_name
        "TerraspaceVcs#{name.camelize}::Interface".constantize.new(options) if name
      end

      def detect_name
        # allow user to override vcs.name
        Terraspace.config.cloud.vcs.name || @@name
      end
    end
  end
end
