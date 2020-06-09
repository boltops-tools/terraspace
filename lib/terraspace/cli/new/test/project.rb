module Terraspace::CLI::New::Test
  class Project < Base
    argument :name

    def create
      return if @options[:test] == false
      test_template_source(@options[:lang], "project")

      puts "=> Creating project test: #{name}"
      dest = "."
      dest = "#{@options[:project_name]}/#{dest}" if @options[:project_name]
      directory ".", dest
    end
  end
end
