module Terraspace::All
  class Runner < Base
    include Terraspace::Util
    extend Memoist

    def initialize(command, options={})
      @command, @options = command, options
      super(options)
    end

    def run
      time_took do
        @batches = build_batches
        preview
        are_you_sure?
        deploy_batches
      end
    end

    def preview
      Preview.new(@command, @batches, @options).show
    end

    def build_batches
      @batches = Terraspace::Dependency::Resolver.new(@options).resolve
      @batches.reverse! if @command == "down"
      @batches
    end

    def deploy_batches
      truncate_logs if ENV['TS_TRUNCATE_LOGS']
      remove_remote_state_cache
      build_modules
      @batches.each_with_index do |batch,i|
        logger.info "Batch Run #{i+1}:"
        deploy_batch(batch)
      end
    end

    def deploy_batch(batch)
      @pids = {} # stores child processes pids. map of pid to mod_name, reset this list on each batch run
      concurrency = Terraspace.config.all.concurrency
      batch.sort_by(&:name).each_slice(concurrency) do |slice|
        slice.each do |node|
          if fork?
            pid = fork do
              deploy_stack(node)
            end
            @pids[pid] = node.name # store mod_name mapping
          else
            deploy_stack(node)
          end
        end
      end
      return unless fork?
      wait_for_child_proccess
      summarize     # also reports lower-level error info
      report_errors # reports finall errors and possibly exit
    end

    def remove_remote_state_cache
      remote_state_dir = "#{Terraspace.tmp_root}/remote_state"

      logger.debug "Removing #{remote_state_dir}"
      FileUtils.rm_rf(remote_state_dir)
    end

    def deploy_stack(node)
      build_stack(node.name)
      run_terraspace(node.name)
    end

    def build_modules
      builder = Terraspace::Builder.new(@options.merge(mod: "placeholder", clean: true, quiet: true, include_stacks: :none))
      builder.build(modules: true)
    end

    def build_stack(name)
      include_stacks = @command == "down" ? :root_with_children : :root_only
      builder = Terraspace::Builder.new(@options.merge(mod: name, clean: false, quiet: true, include_stacks: include_stacks))
      builder.build(modules: false)
    end

    def wait_for_child_proccess
      @errors = [] # stores child processes pids that errored
      @pids.each do |pid, _|
        pid, status = Process.wait2(pid)
        success = status.exitstatus == 0
        @errors << pid unless success
      end
    end

    def report_errors
      @errors.each do |pid|
        mod_name = @pids[pid]
        terraspace_command = terraspace_command(mod_name)
        logger.error "Error running: #{terraspace_command}. Fix the error above or check logs for the error.".color(:red)
      end
      unless @errors.empty?
        exit 2 if exit_on_fail?
      end
    end

    # Precendence:
    # 1. env var
    # 2. cli
    # 3. config/app.rb setting
    def exit_on_fail?
      return false if ENV['TS_EXIT_ON_FAIL'] == '0'
      if @options[:exit_on_fail].nil?
        Terraspace.config.all.exit_on_fail[@command]
      else
        @options[:exit_on_fail]
      end
    end

    def summarize
      @pids.each do |_, mod_name|
        data = {
          command: @command,
          log_path: log_path(mod_name),
          terraspace_command: terraspace_command(mod_name),
        }
        # Its possible for log file to not get created if RemoteState::Fetcher#validate! fails
        Summary.new(data).run if File.exist?(data[:log_path])
      end
    end

    def run_terraspace(mod_name)
      set_log_path!(mod_name) if fork?
      name = command_map(@command)
      o = @options.merge(mod: mod_name, yes: true, build: false, input: false, log_to_stderr: true)
      o.merge!(quiet: false) if @command == "init" # noisy so can filter and summarize output
      case @command
      when "up"
        Terraspace::CLI::Up.new(o).run
      when "down"
        Terraspace::CLI::Down.new(o).run
      when "plan"
        Terraspace::CLI::Plan.new(o).run
      else
        Terraspace::CLI::Commander.new(name, o).run
      end
    end

    def fork?
      Terraspace.config.all.concurrency > 1
    end

    def set_log_path!(mod_name)
      command = terraspace_command(mod_name)
      path = log_path(mod_name)
      pretty_path = Terraspace::Util.pretty_path(path)
      logger.info "Running: #{command.bright} Logs: #{pretty_path}"

      FileUtils.mkdir_p(File.dirname(path))
      logger = Terraspace::Logger.new(path)
      logger.level = Terraspace.config.logger.level # match the level that user configured
      logger.formatter = Terraspace.config.logger.formatter # match the level that user configured
      logger.progname = command
      Terraspace.logger = logger
    end

    def log_path(mod_name)
      "#{Terraspace.config.log.root}/#{@command}/#{mod_name}.log"
    end

    def truncate_logs
      logs = Terraspace::CLI::Log::Tasks.new(mute: true)
      logs.truncate
    end

    def terraspace_command(name)
      "terraspace #{@command} #{name}"
    end

    def command_map(name)
      map = {
        up:   "apply",
        down: "destroy",
      }.stringify_keys
      map[name] || name
    end

    def are_you_sure?
      return true unless sure_command?
      sure? # from Util
    end

    def sure_command?
      %w[up down].include?(@command)
    end

    def time_took
      t1 = Time.now
      yield
      t2 = Time.now
      logger.info "Time took: #{pretty_time(t2-t1)}"
    end
  end
end
