module Terraspace::State
  class Runner < Base
    include Terraspace::Util

    def initialize(command, options={})
      @command, @options = command, options
      super(options)
    end

    def run
      time_took do
        Commander.new("state import", @options.merge(plan: plan_path)).run
        report_errors
      end
    end

    def report_errors
      @errors.each do |pid|
        mod_name = @pids[pid]
        terraspace_command = terraspace_command(mod_name)
        logger.error "Error running: #{terraspace_command}. Check logs and fix the error.".color(:red)
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
        Terraspace.config.state.exit_on_fail[@command]
      else
        @options[:exit_on_fail]
      end
    end

    def time_took
      t1 = Time.now
      yield
      t2 = Time.now
      logger.info "Time took: #{pretty_time(t2-t1)}"
    end
  end
end
