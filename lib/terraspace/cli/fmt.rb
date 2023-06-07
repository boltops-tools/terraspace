class Terraspace::CLI
  class Fmt
    include Concerns::SourceDirs
    include Terraspace::Util::Logging

    @@exit_status = 0

    def initialize(options={})
      @options = options
      @mod_name = options[:mod]
    end

    def run
      logger.info "Formating terraform files"
      dirs.each do |dir|
        err = format(dir)
        if err
          @@exit_status = 1
        end
      end

      exit(@@exit_status)
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
