class Terraspace::CLI::New
  class Stack < Sequence
    component_options.each { |args| class_option(*args) }

    argument :name

    def create_stack
      provider_template_source(@options[:lang], "stack") # IE: provider_template_source("hcl", "stack")

      puts "=> Creating new stack called #{name}."
      dest = "app/stacks/#{name}"
      dest = "#{@options[:project_name]}/#{dest}" if @options[:project_name]
      directory ".", dest
    end

    def create_test
      Test::Project.start([name])
    end
  end
end
