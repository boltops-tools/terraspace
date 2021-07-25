require 'timeout'

class Terraspace::CLI
  class Init < Base
    def initialize(options={})
      # terraform init output goes to default Terraspace.logger.info which is stderr
      # Unless the logger has been overridden.
      super(options.merge(log_to_stderr: true))
    end

    def run
      init
      # build_remote_dependencies # runs after terraform init, which downloads remote modules
      sync_cloud
    end

    # Note the init will always create the Terraform Cloud Workspace
    def init
      return unless run_init? # check here because RemoteState::Fetcher#pull calls init directly
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
      Terraspace::Terraform::Tfc::Sync.new(@options).run if sync_cloud?
    end

    def sync_cloud?
       %w[apply down plan up].include?(calling_command)
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

      remote_mod = Terraspace::Mod::Remote.new(meta, @mod)
      Terraspace::Compiler::Builder.new(remote_mod).build
    end

    def auto?
      # command is only passed from CLI in the update specifically for this check
      @options[:auto] && calling_command == "up"
    end
  private
    def local_source?(s)
       s =~ %r{^\.} || s =~ %r{^/}
    end

    def auto_init?
      # terraspace commands not terraform commands. included some extra terraform commands here in case terrapace adds those later
      commands = %w[all apply console down output plan providers refresh show state up validate]
      commands.include?(calling_command)
    end

    def run_init?
      return false unless auto_init?
      mode = ENV['TS_INIT_MODE'] || Terraspace.config.init.mode
      case mode.to_sym
      when :auto
        !already_init?
      when :always
        true
      when :never
        false
      end
    end

    # Would like to improve this detection
    #
    # Traverse symlink dirs also: linux_amd64 is a symlink
    #   plugins/registry.terraform.io/hashicorp/google/3.39.0/linux_amd64/terraform-provider-google_v3.39.0_x5
    #
    def already_init?
      terraform = "#{@mod.cache_dir}/.terraform"
      provider = Dir.glob("#{terraform}/**{,/*/**}/*").find do |path|
        path.include?("terraform-provider-")
      end
      !!provider
    end

    # only top level command considered
    def calling_command
      Terraspace.argv[0]
    end
  end
end
