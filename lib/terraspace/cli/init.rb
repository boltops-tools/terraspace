require 'timeout'

class Terraspace::CLI
  class Init < Base
    def initialize(options={})
      # Original calling command. Can be from Commander which is a terraform command. IE: terraform apply
      # Or can be from terraspace cloud setup. Which will be cloud-setup.
      @calling_command = options[:calling_command]
      super(options)
    end

    def run
      init if init?
      build_remote_dependencies # runs after terraform init, which downloads remote modules
      sync_cloud
    end

    # Note the init will always create the Terraform Cloud Workspace
    def init
      # default init timeout is pretty generous in case of slow internet to download the provider plugins
      init_timeout = Integer(ENV['TS_INIT_TIMEOUT'] || 600)
      Timeout::timeout(init_timeout) do
        Terraspace::Terraform::Runner.new("init", @options).run if !auto? && @options[:init] != false # will run on @options[:init].nil?
      end
    rescue Timeout::Error
      logger.error "ERROR: It took too long to run terraform init.  Here is the output logs of terraform init:".color(:red)
      logger.error IO.read(Terraspace::Terraform::Args::Default.terraform_init_log)
    end

    def sync_cloud
      Terraspace::Terraform::Cloud.new(@options).run if %w[apply plan destroy cloud-setup].include?(@calling_command)
    end

    # Currently only handles remote modules only one-level deep.
    def build_remote_dependencies
      modules_json_path = "#{@mod.cache_dir}/.terraform/modules/modules.json"
      return unless File.exist?(modules_json_path)

      initialized_modules = JSON.load(IO.read(modules_json_path))
      # For example of structure see spec/fixtures/initialized/modules.json
      initialized_modules["Modules"].each do |meta|
        build_remote_mod(meta)
      end
    end

    def build_remote_mod(meta)
      return if local_source?(meta["Source"])
      return if meta['Dir'] == '.' # root is already built

      remote_mod = Mod::Remote.new(meta, @mod)
      Compiler::Builder.new(remote_mod).build
    end

    def auto?
      # command is only passed from CLI in the update specifically for this check
      @options[:auto] && @calling_command == "apply"
    end
  private
    def local_source?(s)
       s =~ %r{^\.} || s =~ %r{^/}
    end

    def init?
      %w[apply console destroy output plan providers refresh show validate cloud-setup].include?(@calling_command)
    end
  end
end
