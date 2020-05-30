module Terraspace::Tester
  class Meta
    # raw: {"rspec" => {root: "/path"}
    def initialize(raw)
      @raw = raw
    end

    def name
      name = @raw.keys.first
      unless name
        raise "No tester gem found. Are you sure you have the terraspace test gem configured in your Gemfile?"
      end
      name.camelize
    end
    alias_method :tester, :name

    def data
      @raw.values.first
    end

    def root
      data[:root]
    end
  end
end
