require 'logger'

module Terraspace
  class Logger < ::Logger
    def initialize(*args)
      super
      self.formatter = Formatter.new
      self.level = :info
    end

    def format_message(severity, datetime, progname, msg)
      line = if @logdev.dev == $stdout || @logdev.dev == $stderr
        msg # super simple format if stdout
      else
        super # use the configured formatter
      end
      line =~ /\n$/ ? line : "#{line}\n"
    end
  end
end
