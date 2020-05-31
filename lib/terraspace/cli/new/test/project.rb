module Terraspace::CLI::New::Test
  class Project < Base
    argument :name

    def create
      puts "=> Creating project test: #{name}"
      test_template_source("project")
      dest = "."
      dest = "#{@options[:project_name]}/#{dest}" if @options[:project_name]
      directory ".", dest
    end
  end
end
