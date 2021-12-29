class Terraspace::CLI
  class Setup < Terraspace::Command
    desc "check", "Check setup is ok"
    long_desc Help.text("setup/check")
    def check
      Check.new(options).run
    end
  end
end
