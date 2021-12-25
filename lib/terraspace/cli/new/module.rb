class Terraspace::CLI::New
  class Module < Sequence
    component_options.each { |args| class_option(*args) }

    argument :name

    def create_module
      puts "=> Creating new module called #{name}"
      plugin_template_source(@options[:lang], "module") # IE: plugin_template_source("hcl", "module")
      dest = "app/modules/#{name}"
      dest = "#{@options[:project_name]}/#{dest}" if @options[:project_name]
      directory ".", dest
    end
  end
end
