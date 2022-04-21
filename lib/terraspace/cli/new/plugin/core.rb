class Terraspace::CLI::New::Plugin
  class Core < Terraspace::CLI::New::Sequence
    include Helper

    argument :name

    def self.options
      [
        [:force, aliases: %w[y], type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
      ]
    end
    options.each { |args| class_option(*args) }

    def create_plugin
      puts "=> Creating new plugin: #{name}"
      core_template_source("plugin/core")
      directory ".", "terraspace_plugin_#{name}"
    end

  private
    def gem_name
      "terraspace_plugin_#{name}"
    end

  end
end
