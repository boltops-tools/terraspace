class Terraspace::CLI::New
  class GitHook < Thor::Group
    include Thor::Actions

    def self.cli_options
      [
        [:envs, type: :array, default: %w[dev prod], desc: "envs to build"],
        [:type, aliases: %w[t], default: "pre-push", desc: "git hook type"],
      ]
    end
    cli_options.each { |args| class_option(*args) }

    def self.source_root
      File.expand_path("../../../templates/base/git_hook", __dir__)
    end

    def create
      return unless File.exist?(".git")
      dest = ".git/hooks/#{options[:type]}"
      template "hook.sh", dest
      chmod dest, 0755
    end

  private
    def terraspace_build_commands
      code = []
      @options[:envs].each do |env|
        code << %Q|TS_ENV=#{env} terraspace build|
      end
      code.join("\n")
    end
  end
end
