require 'open3'

module Terraspace::Util
  module Popen
    include Logging

    # Similar to Terraspace::Shell#popen3
    # More generalized. Useful for plugins
    def popen(command, options={})
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thread|
        handle_streams(stdin, stdout, stderr, options)
        status = wait_thread.value.exitstatus
        unless status == 0
          logger.error "Error running command #{command}".color(:red)
          exit 1
        end
      end
    end

    BLOCK_SIZE = Integer(ENV['TS_BUFFER_BLOCK_SIZE'] || 102400)
    def handle_streams(stdin, stdout, stderr, options)
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
              handle_stdout(line, options)
            else
              handle_stderr(line, options)
            end
          end
        end
      end
    end

    def handle_stdout(line, options={})
      newline = options[:newline].nil? ? true : options[:newline]
      filter = options[:filter]

      # Terraspace logger has special stdout method so original terraform output
      # can be piped to jq. IE:
      #   terraspace show demo --json | jq
      if logger.respond_to?(:stdout) && !options[:log_to_stderr]
        logger.stdout(line, newline: newline) unless line.include?(filter)
      else
        logger.info(line) unless line.include?(filter)
      end
    end

    def handle_stderr(line, options={})
      logger.error(line) unless line.include?(options[:filter])
    end

    def all_eof?(files)
      files.find { |f| !f.eof }.nil?
    end

  end
end
