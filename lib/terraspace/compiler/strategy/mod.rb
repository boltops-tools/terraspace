module Terraspace::Compiler::Strategy
  class Mod < AbstractBase
    def run
      ext = File.extname(@src_path).sub('.','')
      klass = strategy_class(ext)
      strategy = klass.new(@mod, @src_path) # IE: Terraspace::Compiler::Strategy::Mod::Rb.new
      strategy.run
    end

    def strategy_class(ext)
      return Mod::Pass if ext.empty? # infinite loop without this
      "Terraspace::Compiler::Strategy::Mod::#{ext.camelize}".constantize rescue Mod::Pass
    end
  end
end
