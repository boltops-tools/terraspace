module Terraspace::Compiler
  class Cleaner
    def initialize(mod)
      @mod = mod
    end

    def clean
      return if ENV['TS_NO_CLEAN']
      remove_materialized_artifacts
      # remove_materialized_artifacts_dot_terraform
      remove_empty_directories
    end

    # only remove .tf* files. leaving cache .terraform and terraform.state files
    def remove_materialized_artifacts
      Dir.glob("#{Terraspace.cache_root}/**/*").each do |path|
        next if path.include?(".tfstate")
        FileUtils.rm_f(path) if File.file?(path)
      end
    end

    # Tricky: Reason we remove these artifacts is because they get written to the same source location.
    # So when `terraspace build` is ran twice. The 2nd run will pick up the artifacts and process those again.
    #
    # Comment out for now. Running twice doesnt hurt because it just uses the pass.rb strategy and just copies
    # the file again. With verbose logging, it shows it twice so that's a little bit confusing though.
    #
    # def remove_materialized_artifacts_dot_terraform
    #   expr = "#{@mod.cache_build_dir}/.terraform/**/*"
    #
    #   Dir.glob(expr).each do |path|
    #     puts "path #{path}"
    #   end
    # end

    def remove_empty_directories
      return unless File.exist?(Terraspace.cache_root)
      sh("find #{Terraspace.cache_root} -empty -type d -delete")
    end

    def sh(command)
      `#{command}`
      status = $? # Process::Status object
      unless status.success?
        raise "Error running command: #{command}"
        exit status.exitstatus # code
      end
    end
  end
end
