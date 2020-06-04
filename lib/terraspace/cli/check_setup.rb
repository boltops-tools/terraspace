class Terraspace::CLI
  class CheckSetup
    extend Memoist

    # Terraspace requires at least this version of terraform
    REQUIRED_TERRAFORM_VERSION = "0.12"

    def initialize(options={})
      @options = options
    end

    def run
      puts "Checking setup."
      puts "Detected Terrspace version: #{Terraspace::VERSION}"
      if terraform_bin
        puts "Detected Terraform bin: #{terraform_bin}"
        puts "Detected #{terraform_version_message}"
        check_required_version!
      else
        puts "Terraform not installed. Unable to detect a terraform command. Please double check that terraform is installed."
        exit 1
      end
    end

    def check_required_version!
      puts "Terraspace requires Terraform v#{REQUIRED_TERRAFORM_VERSION}.x"
      if version_ok?
        puts "You're all set!"
      else
        puts "The installed version of terraform may not work with terraspace. Recommend using terraform v#{REQUIRED_TERRAFORM_VERSION}.x"
      end
    end

    def version_ok?
      version = terraform_version_message.sub(/.*v/,'') # => 0.12.24
      major, minor, _ = version.split('.')
      required_major, required_minor = REQUIRED_TERRAFORM_VERSION.split
      major.to_i >= required_major.to_i && minor.to_i >= required_minor.to_i
    end

    def terraform_bin
      bin_path = `which terraform 2>&1`.strip
      bin_path if $?.success?
    end
    memoize :terraform_bin

    # First line contains the Terraform version info:
    #
    #     $ terraform --version
    #     Terraform v0.12.24
    #
    #     Your version of Terraform is out of date! The latest version
    #     is 0.12.26. You can update by downloading from https://www.terraform.io/downloads.html
    #
    def terraform_version_message
      `terraform --version`.split("\n").first.strip
    end
    memoize :terraform_version_message
  end
end
