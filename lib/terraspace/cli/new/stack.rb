class Terraspace::CLI::New
  class Stack < Sequence
    component_options.each { |args| class_option(*args) }

    # default so terraspace new example works without a Thor warning
    argument :name, default: "demo"

    def create_stack
      puts "=> Creating new stack called #{name}"
      plugin_template_source(@options[:lang], "stack") # IE: plugin_template_source("hcl", "stack")
      dest = "app/stacks/#{name}"
      dest = "#{@options[:project_name]}/#{dest}" if @options[:project_name]
      directory ".", dest
    end
  end
end
