class Terraspace::CLI::New
  class Module < Sequence
    component_options.each { |args| class_option(*args) }

    argument :name

    def create_module
      create(@options[:lang]) # IE: create("hcl")
      create("test")
    end

  private
    def create(template)
      set_source(template, "module") # IE: set_source("hcl", "module")

      if template == "test"
        puts "=> Creating new module called: #{name}"
      else
        puts "=> Creating test for new module: #{name}"
      end

      dest = "app/modules/#{name}"
      dest = "#{@options[:project_name]}/#{dest}" if @options[:project_name]
      directory ".", dest
    end
  end
end
