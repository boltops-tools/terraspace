module Terraspace
  class Check
    extend Memoist

    attr_reader :min_terraform_version, :max_terraform_version
    def initialize(options={})
      @options = options
      # Terraspace requires this terraform version or a fork
      @min_terraform_version = "0.12"
      @max_terraform_version = "1.5.5"
    end

    # Used for the CLI
    def run(cloud: false)
      puts "terraspace version: #{Terraspace::VERSION}"
      if terraform_bin
        puts "#{terraform_bin_name} bin: #{pretty_home(terraform_bin)}"
        puts "#{terraform_bin_name} version: #{terraform_version}"
        # check for allowed version of terraform
        if allowed_terraform_version?
          puts "You're all set!".color(:green)
        else
          error_message(cloud: cloud)
          exit 1
        end
      else
        puts terraform_is_not_installed
        exit 1
      end
    end
    alias ok! run

    def error_message(cloud: false)
      name = cloud ? "Terraspace Cloud" : "Terraspace"
      cloud_note =<<~EOL

        Note: If you're using Terraspace Cloud, you won't be able to bypass this check.
        See: https://terraspace.cloud/docs/terraform/license/
      EOL

      puts "ERROR: #{name} requires Terraform between v#{@min_terraform_version}.x and #{@max_terraform_version}".color(:red)
      puts <<~EOL
        This is because newer versions of Terraform has a BSL license
        If your usage is allowed by the license, you can bypass this check with:

            export TS_VERSION_CHECK=0
        #{cloud_note}
      EOL
    end

    # aliased with ok?
    def allowed_terraform_version?
      return true if ENV['TS_VERSION_CHECK'] == '0' && !Terraspace.cloud?
      return false unless terraform_bin
      return true if !terraform_bin.include?("terraform") # IE: allow any version of terraform forks

      major, minor, patch = terraform_version.split('.').map(&:to_i)
      min_major, min_minor, _ = @min_terraform_version.split('.').map(&:to_i)
      max_major, max_minor, max_patch = @max_terraform_version.split('.').map(&:to_i)

      # must be between min and max
      min_ok = major > min_major ||
              (major == min_major && minor >= min_minor)
      max_ok = major < max_major ||
              (major == max_major && minor == max_minor && patch <= max_patch)

      min_ok && max_ok
    end
    alias ok? allowed_terraform_version?

    def terraform_is_not_installed
      <<~EOL
        Terraform not installed. Unable to detect a terraform command.
        Please double check that an allowed version of terraform is installed.
        See: https://terraspace.cloud/docs/install/terraform/
      EOL
    end

    # Note opentf is not an official fork yet. Mocked it out for testing.
    # Should be ready to swap out the official fork name when it is ready.
    BINS = %w[opentf terraform]
    @@terraform_bin = nil
    def terraform_bin
      return @@terraform_bin if @@terraform_bin.present?
      BINS.each do |bin|
        if Gem.win_platform?
          out = "is #{bin}.exe".strip
        else
          out = `type #{bin} 2>&1`.strip
          next unless $?.success?
        end
        md = out.match(/is (.*)/)
        if md
          @@terraform_bin = md[1]
          break
        end
      end
      @@terraform_bin
    end
    memoize :terraform_bin

    def terraform_bin_name
      terraform_bin ? File.basename(terraform_bin) : "terraform"
    end

    # Sometimes Terraform shows the version info on the first line and sometimes on the bottom line.
    # Account for that by finding the line.
    #
    #     $ terraform --version
    #     Terraform v0.12.24
    #
    #     Your version of Terraform is out of date! The latest version
    #     is 0.12.26. You can update by downloading from https://www.terraform.io/downloads.html
    #
    # Another example
    #
    #     $ opentf --version
    #     OpenTF v0.12.24
    #
    # Note: The -json option is only available in v0.13+
    def terraform_version
      out = `#{terraform_bin} --version`
      # 1st regexp is more strict to avoid false positives
      # 2nd regexp is more lenient in include beta suffixes
      line = out.split("\n").find { |l| l =~ /(\d+\.\d+\.\d+)/ }
      version = line.match(/(\d+\.\d+\.\d+.*)/)[1] if line
    end
    memoize :terraform_version

    def terraspace_version
      Terraspace::VERSION
    end

    def versions
      {
        terraspace_version: terraspace_version,
        terraform_version: terraform_version,
        terraform_command: terraform_bin_name,
      }
    end

    def pretty_home(path)
      path.sub(ENV['HOME'], '~')
    end

    class << self
      # Used as library call
      def check!
        setup = new
        return if setup.ok?
        # run meth designed for CLI and will puts out informative messages about installed version and exit 1 when version is not ok
        setup.run
      end
    end
  end
end
