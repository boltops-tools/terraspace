class Terraspace::CLI::Clean
  class All < Base
    def run
      are_you_sure?
      o = @options.merge(yes: true) # override to avoid double prompt
      Cache.new(o).run
      Logs.new(o).run
    end

    def are_you_sure?
      message = <<~EOL.chomp
        Will remove Terraspace cache and logs.
        Are you sure?
      EOL
      sure?(message) # from Util::Sure
    end
  end
end