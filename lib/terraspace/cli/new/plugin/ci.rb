class Terraspace::CLI::New::Plugin
  class Ci < Terraspace::CLI::New::Sequence
    include Helper

    argument :name

    def self.options
      [
        [:force, aliases: %w[y], type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
        [:pr, type: :boolean, desc: "Generate pr code also. Most CI systems don't have PR support"],
      ]
    end
    options.each { |args| class_option(*args) }

    def create_plugin
      puts "=> Creating new ci plugin: #{name}"
      core_template_source("plugin/ci")
      exclude_pattern = "pr\.rb" unless options[:pr]
      directory ".", "terraspace_ci_#{name}", exclude_pattern: exclude_pattern
    end

    def finish_message
      files = [
        "#{gem_name}.gemspec",
        "lib/#{gem_name}.rb",
        "lib/#{gem_name}/vars.rb",
        "lib/#{gem_name}/interface.rb",
        "README.md",
      ]
      files << "lib/#{gem_name}/pr.rb" if @options[:pr]
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
