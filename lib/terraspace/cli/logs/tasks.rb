class Terraspace::CLI::Logs
  class Tasks
    include Terraspace::Util::Sure

    def initialize(options={})
      @options = options
      Terraspace.check_project!
    end

    def truncate
      are_you_sure?("truncate")
      log_files.each do |path|
        File.open(path, "w").close # truncates files
      end
    end

    def remove
      are_you_sure?("remove")
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

    def are_you_sure?(action)
      message = <<~EOL.chomp
        Will #{action} all the log files in #{pretty_log_root}/ folder
        Are you sure?
      EOL
      sure?(message) # from Util::Sure
    end
  end
end
