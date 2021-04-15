module Terraspace::Compiler::Strategy
  class Mod < AbstractBase
    def run
      klass = strategy_class(@src_path)
      strategy = klass.new(@mod, @src_path) # IE: Terraspace::Compiler::Strategy::Mod::Rb.new
      strategy.run
    end

    def strategy_class(path)
      ext = File.extname(path).sub('.','')
      return Mod::Pass if ext.empty? # infinite loop without this
      return Mod::Pass if Terraspace.pass_file?(path)
      "Terraspace::Compiler::Strategy::Mod::#{ext.camelize}".constantize rescue Mod::Pass
    end
  end
end
