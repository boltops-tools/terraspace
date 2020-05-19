class Terraspace::CLI
  class Base
    def initialize(options={})
      @options = options.dup # dup to unthaw frozen thor options
      @mod = Terraspace::Mod.new(options[:mod]) # mod metadata
      @mod.check_exist!
    end
  end
end
