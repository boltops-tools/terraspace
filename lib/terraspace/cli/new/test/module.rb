module Terraspace::CLI::New::Test
  class Module < Base
    argument :name

    def create
      puts "=> Creating module test: #{name}"
      test_template_source(@options[:lang], "module")
      dest = "app/modules/#{name}"
      dest = "#{@options[:project_name]}/#{dest}" if @options[:project_name]
      directory ".", dest
    end
  end
end
