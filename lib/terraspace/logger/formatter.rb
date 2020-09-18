class Terraspace::Logger
  class Formatter < ::Logger::Formatter
    def call(severity, time, progname, msg)
      # careful changing the format. All::Summary uses a regexp on this format to remove the timestamp
      "[#{format_datetime(time)} ##{Process.pid} #{progname}]: #{msg}"
    end

  private
    def format_datetime(time)
      time.strftime("%Y-%m-%dT%H:%M:%S")
    end
  end
end
