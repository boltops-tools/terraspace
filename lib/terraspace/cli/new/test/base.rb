module Terraspace::CLI::New::Test
  class Base < Thor::Group
    include Thor::Actions
    include Terraspace::CLI::New::Helper

  private
    def test_template_source(type)
      source = Terraspace::CLI::New::Source::Test.new(self, @options)
      source.set_source_paths(type)
    end
  end
end
