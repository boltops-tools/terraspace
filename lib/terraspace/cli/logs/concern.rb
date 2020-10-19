class Terraspace::CLI::Logs
  module Concern
    # Filters for lines that belong to the last ran process pid
    def readlines(path)
      lines = IO.readlines(path)
      found = lines.reverse.find do |line|
        pid(line) # search in reverse order for lines with interesting info
      end
      unless found
        puts "WARN: Could not find the pid in the logfile #{Terraspace::Util.pretty_path(path)}".color(:yellow)
        return []
      end

      pid = pid(found)
      lines.select {|l| l.include?(" ##{pid} ") }
    end

    # [2020-09-06T21:58:25 #11313 terraspace up b1]:
    def pid(line)
      return @options[:pid] if @options && @options[:pid] # Terraspace::All::Summary: doesnt have @options set
      md = line.match(/:\d{2} #(\d+) /)
      md[1] if md
    end
  end
end
