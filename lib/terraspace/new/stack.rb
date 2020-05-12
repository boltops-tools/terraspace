class Terraspace::New
  class Stack < Sequence
    component_options.each { |args| class_option(*args) }

    argument :name

    def set_source_path
      set_source("stack", blank: !options[:examples])
    end

    def create_module
      puts "=> Creating new stack called #{name}."
      dest = "app/stacks/#{name}"
      dest = "#{options[:project_name]}/#{dest}" if options[:project_name]
      directory ".", dest
    end
  end
end
