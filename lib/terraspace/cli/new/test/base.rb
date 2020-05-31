module Terraspace::CLI::New::Test
  class Base < Thor::Group
    include Thor::Actions
    include Terraspace::CLI::New::Helper

    # Reuse options form Sequence. Tried separting them out and it's not worth it.
    # It introduced too much duplication.
    Terraspace::CLI::New::Sequence.base_options.each { |args| class_option(*args) }
    Terraspace::CLI::New::Sequence.component_options.each { |args| class_option(*args) }

  private
    def test_template_source(type)
      source = Terraspace::CLI::New::Source::Test.new(self, @options)
      source.set_source_paths(type)
    end
  end
end
