require "open3"

class Terraspace::Compiler::Strategy::Mod
  class TextFile
    include Terraspace::Util::Logging

    def initialize(filename)
      @filename = filename
    end

    def check
      return true if Gem.win_platform? # assume text file if on windows
      return true unless file_installed?

      # Thanks: https://stackoverflow.com/questions/2355866/ruby-how-to-determine-if-file-being-read-is-binary-or-text
      file_type, status = Open3.capture2e("file", @filename)
      status.success? && file_type.include?("text")
    end

  private
    @@has_file = nil
    def file_installed?
      return @@has_file unless @@has_file.nil?
      @@has_file = system("type file > /dev/null 2>&1")
      unless @@has_file
        logger.warn <<~EOL.color(:yellow)
          WARN: The command 'file' is not installed.
          Unable to check if files are text or binary files as a part of the Terraspace compile processing.
          Assuming all files are not binary file.
          Please install the file command to remove this warning message.
        EOL
      end
     @@has_file
    end
  end
end
