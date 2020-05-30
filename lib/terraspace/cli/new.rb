class Terraspace::CLI
  class New < Terraspace::Command
    long_desc Help.text(:module)
    Module.base_options.each { |args| option(*args) }
    Module.component_options.each { |args| option(*args) }
    register(Module, "module", "module NAME", "Generates new module")

    long_desc Help.text(:stack)
    Stack.base_options.each { |args| option(*args) }
    Stack.component_options.each { |args| option(*args) }
    register(Stack, "stack", "stack NAME", "Generates new stack")

    long_desc Help.text(:new)
    Project.base_options.each { |args| option(*args) }
    Project.project_options.each { |args| option(*args) }
    register(Project, "project", "project NAME", "Generates new project")

    long_desc Help.text(:test)
    register(Test, "test", "test NAME", "Generates new test")
  end
end
