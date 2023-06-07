class Terraspace::CLI
  class Fmt
    include Concerns::SourceDirs
    include Terraspace::Util::Logging

    def initialize(options={})
      @options = options
      @mod_name = options[:mod]
    end

    def run
      logger.info "Formating terraform files"
      exit_status = nil
      dirs.each do |dir|
        exit_status = format(dir)
      end
      exit(exit_status)
    end

    def format(dir)
      Runner.new(dir).format!
    end

  private
    def dirs
      if @mod_name
        type_dirs.select { |p| p.include?(@mod_name) }
      else
        type_dirs
      end
    end

    def type_dirs
      type = @options[:type]
      if type && type != "all"
        app_source_dirs.select { |p| p.include?("/#{type.pluralize}/") }
      else
        app_source_dirs
      end
    end
  end
end
