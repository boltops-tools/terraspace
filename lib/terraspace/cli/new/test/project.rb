module Terraspace::CLI::New::Test
  class Project < Base
    argument :name

    def create
      puts "=> Creating project test: #{name}"
      test_template_source("project")
      directory ".", "."
    end
  end
end
