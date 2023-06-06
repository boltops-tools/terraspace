class Terraspace::CLI::Fmt
  class Runner
    include Terraspace::CLI::Concerns::SourceDirs
    include Terraspace::Util::Logging
    SKIP_PATTERN = /\.skip$/

    def initialize(dir)
      @dir = dir
    end

    def format!
      logger.info @dir.color(:green)
      err = 0

      Dir.chdir(@dir) do
        skip_rename
        begin
          err = terraform_fmt
        ensure
          restore_rename
        end
      end

      return err
    end

    def skip_rename
      tf_files.each do |path|
        if !skip?(path) && erb?(path)
          FileUtils.mv(path, "#{path}.skip")
        end
      end
    end

    def terraform_fmt
      return sh "terraform fmt"
    end

    def sh(command)
      logger.debug("=> #{command}")
      success = system(command)
      return if success

      logger.info "WARN: There were some errors running terraform fmt for files in #{@dir}:".color(:yellow)
      logger.info "The errors are shown above"
      return 1
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
