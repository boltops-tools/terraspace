class Terraspace::CLI::New
  class Module < Sequence
    component_options.each { |args| class_option(*args) }

    argument :name

    def create_module
      puts "=> Creating test for new module: #{name}"
      provider_template_source(@options[:lang], "module") # IE: provider_template_source("hcl", "module")
      dest = "app/modules/#{name}"
      dest = "#{@options[:project_name]}/#{dest}" if @options[:project_name]
      directory ".", dest
    end

    def create_test
      Test::Module.start([name])
    end
  end
end
