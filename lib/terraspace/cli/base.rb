class Terraspace::CLI
  class Base
    extend Memoist
    include Terraspace::Util

    def initialize(options={})
      @options = options
      @mod = Terraspace::Mod.new(options[:mod], @options) # mod metadata
      @mod.check_exist!
    end
  end
end
