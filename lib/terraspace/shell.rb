require 'open3'

module Terraspace
  class Shell
    include Util::Logging

    def initialize(mod, command, options={})
      @mod, @command, @options = mod, command, options
    end

    # requires @mod to be set
    # quiet useful for RemoteState::Fetcher
    def run
      msg = "=> #{@command}"
      @options[:quiet] ? logger.debug(msg) : logger.info(msg)
      return if ENV['TS_TEST']
      shell
    end

    def shell
      env = @options[:env] || {}
      env.stringify_keys!
      if system?
        system(env, @command, chdir: @mod.cache_dir)
      else
        popen3(env)
      end
    end

    def system?
      @options[:shell] == "system" || # terraspace console
      ENV['TS_RUNNER_SYSTEM'] # allow manual override
    end

    def popen3(env)
      Open3.popen3(env, @command, chdir: @mod.cache_dir) do |stdin, stdout, stderr, wait_thread|
        handle_streams(stdin, stdout, stderr)
        status = wait_thread.value.exitstatus
        exit_status(status)
      end
    end

    BLOCK_SIZE = Integer(ENV['TS_BUFFER_BLOCK_SIZE'] || 102400)
    BUFFER_TIMEOUT = Integer(ENV['TS_BUFFER_TIMEOUT'] || 3600) # 3600s = 1h
    def handle_streams(stdin, stdout, stderr)
      # note: t=0 and t=nil means no timeout. See: https://bit.ly/2PURlCX
      t = BUFFER_TIMEOUT.to_i unless BUFFER_TIMEOUT.nil?
      Timeout::timeout(t) do
        files = [stdout, stderr]
        until all_eof?(files) do
          ready = IO.select(files)
          next unless ready

          readable = ready[0]
          readable.each do |f|
            buffer = f.read_nonblock(BLOCK_SIZE, exception: false)
            next unless buffer

            lines = buffer.split("\n")
            lines.each do |line|
              if f.fileno == stdout.fileno
                handle_stdout(line, newline: !suppress_newline(line))
                handle_input(stdin, line)
              else
                handle_stderr(line)
              end
            end
          end
        end
      end
    end

    def suppress_newline(line)
      line.size == 8192 && line[-1] != "\n" || # when buffer is very large buffer.split("\n") only gives 8192 chars at a time
      line.include?("Enter a value:") # prompt
    end

    def handle_stderr(line)
      @error ||= Error.new
      @error.lines << line # aggregate all error lines

      return if @error.known?
      # Sometimes may print a "\e[31m\n" which like during dependencies fetcher init
      # suppress it so dont get a bunch of annoying "newlines"
      return if line == "\e[31m\n" && @options[:suppress_error_color]

      logger.error(line)
    end

    def all_eof?(files)
      files.find { |f| !f.eof }.nil?
    end

    def handle_input(stdin, line)
      patterns = [
        "Enter a value:",
        "\e[0m\e[1mvar.", # prompts for variable input. can happen on plan or apply. looking for bold marker also in case "var." shows up somewhere else
      ]
      if patterns.any? { |pattern| line.include?(pattern) }
        answer = $stdin.gets
        stdin.write_nonblock(answer)
      end
    end

    def exit_status(status)
      return if status == 0

      exit_on_fail = @options[:exit_on_fail].nil? ? true : @options[:exit_on_fail]
      if @error && @error.known?
        raise @error.instance
      elsif exit_on_fail
        logger.error "Error running command: #{@command}".color(:red)
        exit status
      end
    end

    def handle_stdout(line, newline: true)
      # Terraspace logger has special stdout method so original terraform output
      # can be piped to jq. IE:
      #   terraspace show demo --json | jq
      if logger.respond_to?(:stdout) && !@options[:log_to_stderr]
        logger.stdout(line, newline: newline)
      else
        logger.info(line)
      end
    end
  end
end
