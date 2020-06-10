require "terraspace-bundler"
TerraspaceBundler.logger = Terraspace.logger

class Terraspace::CLI
  class Bundle
    def initialize(options={})
      @options = options
    end

    def run
      TerraspaceBundler::CLI.start(args)
    end

    # Allows bundle to be called without install. So both work:
    #
    #    terraspace bundle
    #    terraspace bundle install
    #
    def args
      args = @options[:args]
      if args.empty? or args.first.include?('--')
        args.unshift("install")
      end
      args = ["bundle"] + args
      args
    end
  end
end
