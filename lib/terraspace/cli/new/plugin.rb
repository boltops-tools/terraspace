class Terraspace::CLI::New
  class Plugin < Sequence
    include Helper

    def self.options
      [
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
      ]
    end
    options.each { |args| class_option(*args) }

    argument :name

    def create_plugin
      puts "=> Creating new plugin: #{name}"
      core_template_source("plugin")
      directory ".", "terraspace_plugin_#{name}"
    end
  end
end
