class Terraspace::CLI::Logs
  class Tasks
    def initialize(options={})
      @options = options
    end

    def truncate
      puts "Truncating log files in #{pretty_log_root}/" unless @options[:mute]
      log_files.each do |path|
        File.open(path, "w").close # truncates files
      end
    end

    def remove
      puts "Removing all files in #{pretty_log_root}/" unless @options[:mute]
      FileUtils.rm_rf(log_root)
      FileUtils.mkdir_p(log_root)
    end

    def log_files
      Dir.glob("#{log_root}/**/*.log")
    end

    def pretty_log_root
      Terraspace::Util.pretty_path(log_root)
    end

    def log_root
      Terraspace.config.log.root
    end
  end
end
