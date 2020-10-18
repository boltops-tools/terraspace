class Terraspace::CLI
  class Clean < Terraspace::Command
    class_option :yes, aliases: :y, type: :boolean, desc: "bypass are you sure prompt"

    desc "all", "Runs all clean operations."
    long_desc Help.text("clean/all")
    def all
      All.new(options).run
    end

    desc "cache", "Removes cache dirs."
    long_desc Help.text("clean/cache")
    def cache
      Cache.new(options).run
    end

    desc "logs", "Removes or truncate logs."
    long_desc Help.text("clean/logs")
    option :truncate, aliases: :t, type: :boolean, desc: "Truncate instead of remove logs"
    def logs
      Logs.new(options).run
    end
  end
end
