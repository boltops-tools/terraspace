class Terraspace::CLI
  class Logs < Terraspace::Command
    class_option :yes, aliases: :y, type: :boolean, desc: "bypass are you sure prompt"

    desc "truncate", "Truncates logs. IE: Keeps the files but removes contents and zero bytes the files."
    long_desc Help.text("logs/truncate")
    def truncate
      Tasks.new(options).truncate
    end

    desc "remove", "Removes logs"
    long_desc Help.text("logs/remove")
    def remove
      Tasks.new(options).remove
    end
  end
end
