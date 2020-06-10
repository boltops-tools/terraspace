module Terraspace::Util
  module Sure
    def sure?(message="Are you sure?", desc=nil)
      if @options[:yes]
        sure = 'y'
      else
        out = if desc
          "\n#{desc}\n#{message} (y/N) "
        else
          "#{message} (y/N) "
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
