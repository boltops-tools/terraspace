require 'logger'

module Terraspace
  class Logger < ::Logger
    def initialize(*args)
      super
      self.formatter = Formatter.new
      self.level = ENV['TS_LOG_LEVEL'] || :info # note: only respected when config.logger not set in config/app.rb
    end

    def format_message(severity, datetime, progname, msg)
      line = if @logdev.dev == $stdout || @logdev.dev == $stderr
        msg # super simple format if stdout
      else
        super # use the configured formatter
      end
      out = line =~ /\n$/ ? line : "#{line}\n"
      @@buffer << out
      out
    end

    # Used to allow terraform output to always go to stdout
    # Terraspace output goes to stderr by default
    # See: terraspace/shell.rb
    def stdout(msg, newline: true)
      out = newline ? "#{msg}\n" : msg
      @@buffer << out
      print out
    end

    def stdin_capture(text)
      @@buffer << "#{text}\n"
      @@stdin_capture = text
    end

    class << self
      @@stdin_capture = ''
      def stdin_capture
        @@stdin_capture
      end

      @@buffer = []
      def buffer
        @@buffer
      end

      def logs
        @@buffer.join('')
      end

      # for test framework
      def clear
        Terraspace::Command.reset_dispatch_command
        @@buffer = []
      end
    end
  end
end
