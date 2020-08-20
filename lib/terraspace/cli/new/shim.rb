class Terraspace::CLI::New
  class Shim < Thor::Group
    include Thor::Actions

    def self.cli_options
      [
        [:path, aliases: %w[p], default: "/usr/local/bin/terraspace", desc: "path to save the shim script"],
      ]
    end
    cli_options.each { |args| class_option(*args) }

    def self.source_root
      File.expand_path("../../../templates/base/shim", __dir__)
    end

    def set_vars
      @path = @options[:path]
    end

    def create
      return unless File.exist?(".git")
      dest = @path
      template "terraspace", dest
      chmod dest, 0755
    end

    def message
      dir = File.dirname(@path)
      puts <<~EOL
        A terraspace shim as been generated at #{@path}
        Please make sure that it is found in the $PATH.

        You can double check with:

            which terraspace

        You should see

            $ which terraspace
            #{@path}

        If you do not, please add #{dir} to your PATH.
        You can usually do so by adding this line to ~/.bash_profile and opening a new terminal to check.

            export PATH=#{dir}:/$PATH

      EOL
    end

  private
    def switch_ruby_version_line
      rbenv_installed = system("type rbenv 2>&1 > /dev/null")
      if rbenv_installed
        'eval "$(rbenv init -)"'
      end
    end
  end
end
