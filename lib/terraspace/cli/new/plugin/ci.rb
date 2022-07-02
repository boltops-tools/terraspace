class Terraspace::CLI::New::Plugin
  class Ci < Terraspace::CLI::New::Sequence
    include Helper

    argument :name

    def self.options
      [
        [:force, aliases: %w[y], type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
      ]
    end
    options.each { |args| class_option(*args) }

    def create_plugin
      puts "=> Creating new ci plugin: #{name}"
      core_template_source("plugin/ci")
      directory ".", "terraspace_ci_#{name}"
    end

    def finish_message
      files = [
        "#{gem_name}.gemspec",
        "lib/#{gem_name}.rb",
        "lib/#{gem_name}/vars.rb",
        "lib/#{gem_name}/interface.rb",
        "README.md",
      ]
      files.sort!
      list = files.map { |file| "    #{file}" }.join("\n")
      puts <<~EOL
      Files in #{gem_name} to review and update:

      #{list}
      EOL
    end

  private
    def gem_name
      "terraspace_ci_#{name}"
    end

  end
end
