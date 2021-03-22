class Terraspace::CLI
  class Fmt
    include Concerns::SourceDirs
    include Terraspace::Util::Logging

    def initialize(options={})
      @options = options
    end

    def run
      logger.info "Formating terraform files"
      app_source_dirs.each do |dir|
        format(dir)
      end
    end

    def format(dir)
      Runner.new(dir).format!
    end
  end
end
