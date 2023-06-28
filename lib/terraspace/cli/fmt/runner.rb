class Terraspace::CLI::Fmt
  class Runner
    include Terraspace::CLI::Concerns::SourceDirs
    include Terraspace::Util::Logging
    SKIP_PATTERN = /\.skip$/

    def initialize(dir, check_only)
      @dir = dir
      @check_only = check_only
    end

    def format!
      logger.info @dir.color(:green)

      exit_status = nil
      Dir.chdir(@dir) do
        skip_rename
        begin
          exit_status = terraform_fmt
        ensure
          restore_rename
        end
      end
      exit_status
    end

    def skip_rename
      tf_files.each do |path|
        if !skip?(path) && erb?(path)
          FileUtils.mv(path, "#{path}.skip")
        end
      end
    end

    def terraform_fmt
      if @check_only
        sh "terraform fmt -check"
      else
        sh "terraform fmt"
      end
    end

    def sh(command)
      logger.debug("=> #{command}")
      success = system(command)
      unless success
        logger.info "WARN: There were some errors running terraform fmt for files in #{@dir}:".color(:yellow)
        if @check_only
          logger.info "Files that need formatting and any other errors are shown above"
        else
          logger.info "The errors are shown above"
        end
      end
      $?.exitstatus
    end

    def restore_rename
      tf_files.each do |path|
        if skip?(path) && erb?(path)
          FileUtils.mv(path, path.sub(SKIP_PATTERN, '')) # original name
        end
      end
    end

  private
    def skip?(path)
      !!(path =~ SKIP_PATTERN)
    end

    def erb?(path)
      IO.readlines(path).detect { |l| l.include?('<%') }
    end

    def tf_files
      Dir.glob("#{Terraspace.root}/#{@dir}/**/*.{tf,skip}").select { |p| File.file?(p) }
    end
  end
end
