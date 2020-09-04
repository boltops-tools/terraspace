class Terraspace::CLI
  module TfcConcern
    extend Memoist

    def tfc?
      !!backend["remote"]
    end

    def backend
      Terraspace::Compiler::Backend::Parser.new(@mod).result
    end
    memoize :backend
  end
end
