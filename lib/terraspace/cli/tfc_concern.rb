class Terraspace::CLI
  module TfcConcern
    extend Memoist

    def tfc?
      !!backend["remote"]
    end

    def backend
      Terraspace::Terraform::Runner::Backend::Parser.new(@mod).result
    end
    memoize :backend
  end
end
