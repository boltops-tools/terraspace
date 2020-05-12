class Terraspace::New
  class Module < Sequence
    component_options.each { |args| class_option(*args) }

    argument :name

    def set_source_path
      set_source("module", blank: !options[:examples])
    end

    def create_module
      puts "=> Creating new module called #{name}."
      dest = "app/modules/#{name}"
      dest = "#{options[:project_name]}/#{dest}" if options[:project_name]
      directory ".", dest
    end
  end
end
