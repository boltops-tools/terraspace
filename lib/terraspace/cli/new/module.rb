class Terraspace::CLI::New
  class Module < Sequence
    component_options.each { |args| class_option(*args) }

    argument :name

    def create_module
      puts "=> Creating test for new module: #{name}"
      plugin_template_source(@options[:lang], "module") # IE: plugin_template_source("hcl", "module")
      dest = "app/modules/#{name}"
      dest = "#{@options[:project_name]}/#{dest}" if @options[:project_name]
      directory ".", dest
    end

    def create_test
      args = component_args(name, @options[:project_name])
      Test::Module.start(args)
    end

    def run_generator_hook_script
      script = ENV['TS_GENERATOR_MODULE']
      return unless script
      run_script(script, "app/modules/#{name}")
    end
  end
end
