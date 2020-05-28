module Terraspace::Util
  module Sure
    def sure?(message, desc=nil)
      if @options[:yes]
        sure = 'y'
      else
        out = message
        if desc
          out += "\n#{desc}\nAre you sure? (y/N) "
        else
          out += " (y/N) "
        end
        print out
        sure = $stdin.gets
      end

      unless sure =~ /^y/
        puts "Whew! Exiting."
        exit 0
      end
    end
  end
end
