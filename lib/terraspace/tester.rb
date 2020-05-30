module Terraspace
  module Tester
    extend Memoist

    # The tester metadata
    #
    # Example meta:
    #
    #    {
    #      "rspec"  => {root: "/path"}
    #    }
    #
    @@meta = {}
    def meta
      @@meta
    end

    def register(tester, data)
      @@meta[tester] = data
    end

    def find_with(options={})
      Finder.new.find_with(options)
    end
    memoize :find_with

    extend self
  end
end
