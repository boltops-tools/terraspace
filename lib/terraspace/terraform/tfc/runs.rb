module Terraspace::Terraform::Tfc
  class Runs < Terraspace::CLI::Base
    def list
      lister = Lister.new(@mod, @options)
      lister.run
    end

    def prune
      pruner = Pruner.new(@mod, @options)
      pruner.run
    end
  end
end
