require 'logger'

module Terraspace
  class Logger < ::Logger
    # Only need to override the add method as the other calls all lead to it.
    def add(severity, message = nil, progname = nil)
      # Taken from Logger#add source
      # https://ruby-doc.org/stdlib-2.5.1/libdoc/logger/rdoc/Logger.html#method-i-add
      if message.nil?
        if block_given?
          message = yield
        else
          message = progname
          progname = @progname
        end
      end

      super # original logic
    end

    # plain formatting
    def format_message(severity, timestamp, progname, msg)
      "#{msg}\n"
    end
  end
end
