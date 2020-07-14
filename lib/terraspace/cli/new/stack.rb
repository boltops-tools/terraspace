class Terraspace::CLI::New
  class Stack < Sequence
    component_options.each { |args| class_option(*args) }

    argument :name

    def create_stack
      plugin_template_source(@options[:lang], "stack") # IE: plugin_template_source("hcl", "stack")

      puts "=> Creating new stack called #{name}."
      dest = "app/stacks/#{name}"
      dest = "#{@options[:project_name]}/#{dest}" if @options[:project_name]
      directory ".", dest
    end

    def create_test
      Test::Project.start(component_args(name, @options[:project_name]))
    end

    def run_generator_hook_script
      script = ENV['TS_GENERATOR_STACK']
      return unless script
      run_script(script, "app/stacks/#{name}")
    end
  end
end
