module Terraspace
  class Clean
    def initialize(options={})
      @options = options
    end

    def run
      FileUtils.rm_rf(Terraspace.cache_root)
      puts "Removed #{Terraspace::Util.pretty_path(Terraspace.cache_root)}"
    end
  end
end