class Terraspace::CLI
  class Setup < Terraspace::Command
    desc "check", "Check setup is ok", hide: true
    long_desc Help.text("check")
    def check
      puts <<~EOL
        DEPRECATED: The terraspace setup check command is deprecated. Instead use:

            terraspace check

      EOL
      Terraspace::Check.new(options).run
    end
  end
end
