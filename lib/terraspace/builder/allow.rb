class Terraspace::Builder
  class Allow
    def initialize(mod)
      @mod = mod
    end

    def check!
      Env.new(@mod).check!
      Stack.new(@mod).check!
      Region.new(@mod).check!
    end
  end
end
