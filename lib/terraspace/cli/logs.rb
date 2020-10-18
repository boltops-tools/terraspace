require "eventmachine"
require "eventmachine-tail"

class Terraspace::CLI
  class Logs < Base
    include Concern

    def initialize(options={})
      super
      @action, @stack = options[:action], options[:stack]
      @action ||= '**'
      @stack  ||= '*'
    end

    def run
      check_logs!
      if @options[:follow]
        follow_logs
      else
        all_log_paths.each { |path| show_log(path) }
      end
    end

    def follow_logs
      glob_path = "#{Terraspace.log_root}/#{@action}/#{@stack}.log"
      Dir.glob(glob_path).each do |path|
        puts "Following #{pretty(path)}".color(:purple)
      end
      EventMachine.run do
        interval = Integer(ENV['TS_LOG_GLOB_INTERNAL'] || 1)
        EventMachine::FileGlobWatchTail.new(glob_path, nil, interval) do |filetail, line|
          puts line # always show timestamp in follow mode
        end
      end
    end

    def show_log(path)
      report_log(path)
      lines = readlines(path)
      lines = apply_limit(lines)
      lines.each do |line|
        puts format(line)
      end
    end

    def report_log(path)
      pretty_path = pretty(path)
      if File.exist?(path)
        puts "Showing: #{pretty_path}".color(:purple)
      end
    end

    def format(line)
      if timestamps
        line
      else
        line.sub(/.*\]: /,'')
      end
    end

    def all_log_paths
      Dir.glob("#{Terraspace.log_root}/#{@action}/#{@stack}.log")
    end

    def check_logs!
      return unless all_log_paths.empty?
      puts "WARN: No logs found".color(:yellow)
    end

    # Only need to check if both action and stack are provided. Otherwise the Dir.globs are used to discover the files
    def check_log!
      return unless single_log?
      path = "#{Terraspace.log_root}/#{@action}/#{@stack}.log"
      return if File.exist?(path)
      puts "ERROR: Log file was not found: #{pretty(path)}".color(:red)
      exit 1
    end

    def single_log?
      @action != '**' && @stack != '*'
    end

    def apply_limit(lines)
      return lines if all
      left = limit * -1
      lines[left..-1] || []
    end

    def all
      if single_log?
        @options[:all].nil? ? true : @options[:all]
      else # multiple
        @options[:all].nil? ? false : @options[:all]
      end
    end

    def limit
      @options[:limit].nil? ? 10 : @options[:limit]
    end

    def timestamps
      if single_log?
        @options[:timestamps].nil? ? false : @options[:timestamps]
      else
        @options[:timestamps].nil? ? true : @options[:timestamps]
      end
    end
    def pretty(path)
      Terraspace::Util.pretty_path(path)
    end
  end
end
