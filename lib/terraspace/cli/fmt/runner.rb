class Terraspace::CLI::Fmt
  class Runner
    include Terraspace::CLI::Concerns::SourceDirs
    include Terraspace::Util::Logging

    def initialize(dir, options)
      @dir, @options = dir, options
    end

    def format!
      logger.info @dir.color(:green)

      exit_status = nil
      Dir.chdir(@dir) do
        rename_to_skip_fmt
        begin
          exit_status = terraform_fmt
        ensure
          restore_rename
        end
      end
      exit_status
    end

    def rename_to_skip_fmt
      tf_files.each do |path|
        if !skip?(path) && erb?(path)
          FileUtils.mv(path, "#{path}.skip")
        end
      end
    end

    def terraform_fmt
      sh "#{Terraspace.terraform_bin} fmt #{args}"
    end

    def args
      mod = nil # not needed here
      pass = Terraspace::Terraform::Args::Pass.new(mod, "fmt", @options)
      pass.args.flatten.join(' ')
    end

    def sh(command)
      logger.debug("=> #{command}")
      system(command)
      case $?.exitstatus
      when 2 # errors fmt
        logger.info "WARN: There were some errors running #{Terraspace.terraform_bin} fmt for files in #{@dir}:".color(:yellow)
        logger.info "The errors are shown above"
      when 3 # fmt ran and changes were made
        logger.debug "fmt ran and changes were made unless -check or -write=false"
      end
      $?.exitstatus
    end

    SKIP_PATTERN = /\.skip$/
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
