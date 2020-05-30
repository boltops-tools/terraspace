module Terraspace::CLI::New::Test
  class Base < Thor::Group
    include Thor::Actions
    include Terraspace::CLI::New::Helper

    def self.base_options
      [
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
      ]
    end

    base_options.each { |args| class_option(*args) }

  private
    def test_template_source(type)
      source = Terraspace::CLI::New::Source::Test.new(self, @options)
      source.set_source_paths(type)
    end
  end
end
