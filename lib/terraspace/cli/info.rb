class Terraspace::CLI
  class Info < Base
    extend Memoist

    def run
      format = @options[:format] || "text"
      send("#{format}_output")
    end

    def json_output
      puts JSON.pretty_generate(info)
    end

    def text_output
      info.each do |k,v|
        k = "%-#{rpad}s" % k
        puts "#{k} #{v}"
      end
    end

    def rpad
      info.keys.map(&:size).max
    end
    memoize :rpad

    def info
      @mod.to_info
    end
  end
end
