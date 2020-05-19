class Terraspace::CLI
  class Base
    def initialize(options={})
      @options = options
      @mod = Terraspace::Mod.new(options[:mod]) # mod metadata
      @mod.check_exist!
    end
  end
end
