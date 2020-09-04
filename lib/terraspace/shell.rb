require 'open3'

module Terraspace
  class Shell
    include Util::Logging

    def initialize(mod, command, options={})
      @mod, @command, @options = mod, command, options
      @init_required, @init_messages = false, ''
    end

    # requires @mod to be set
    def run
      env = @options[:env] || {}
      env.stringify_keys!

      # quiet useful for RemoteState::Fetcher
      msg = "=> #{@command}"
      @options[:quiet] ? logger.debug(msg) : logger.info(msg)
      return if ENV['TS_TEST']

      Open3.popen3(env, @command, chdir: @mod.cache_dir) do |stdin, stdout, stderr, wait_thread|
        mimic_terraform_input(stdin, stdout)
        while err = stderr.gets
          @init_required ||= reinitialization_required?(err)
          if @init_required
            @init_messages << err
          else
            logger.error(err)
          end
        end

        status = wait_thread.value.exitstatus
        exit_status(status)
      end
    end

    def exit_status(status)
      return if status == 0

      exit_on_fail = @options[:exit_on_fail].nil? ? true : @options[:exit_on_fail]
      if @init_required
        raise InitRequiredError.new(@init_messages)
      elsif exit_on_fail
        logger.error "Error running command: #{@command}".color(:red)
        exit status
      end
    end

    def reinitialization_required?(err)
      err.include?("reinitialization required") ||
      err.include?("terraform init") ||
      err.include?("require reinitialization")
    end

    # Terraform doesnt seem to stream the line that prompts with "Enter a value:" when using Open3.popen3
    # Hack around it by mimicking the "Enter a value:" prompt
    #
    # Note: system does stream the prompt but using Open3.popen3 so we can capture output to save to logs.
    def mimic_terraform_input(stdin, stdout)
      shown = false
      patterns = [
        "Only 'yes' will be accepted", # prompt for apply. can happen on apply
        "\e[0m\e[1mvar.", # prompts for variable input. can happen on plan or apply. looking for bold marker also in case "var." shows up somewhere else
      ]
      while out = stdout.gets
        logger.info(out) unless shown && out.include?("Enter a value:")
        shown = false if out.include?("Enter a value:") # reset shown in case of multiple input prompts

        # Sometimes stdout doesnt flush and show "Enter a value: ", so mimic it
        if patterns.any? { |pattern| out.include?(pattern) }
          print "  Enter a value: ".bright
          shown = true
          stdin.write_nonblock($stdin.gets)
        end
      end
    end
  end
end
