class Terraspace::CLI
  class New < Terraspace::Command
    long_desc Help.text(:git_hook)
    GitHook.cli_options.each { |args| option(*args) }
    register(GitHook, "git_hook", "git_hook", "Generates new git hook")

    long_desc Help.text(:shim)
    Shim.cli_options.each { |args| option(*args) }
    register(Shim, "shim", "shim", "Generates terraspace shim")

    long_desc Help.text(:module)
    Module.base_options.each { |args| option(*args) }
    Module.component_options.each { |args| option(*args) }
    register(Module, "module", "module NAME", "Generates new module")

    long_desc Help.text(:stack)
    Stack.base_options.each { |args| option(*args) }
    Stack.component_options.each { |args| option(*args) }
    register(Stack, "stack", "stack NAME", "Generates new stack")

    long_desc Help.text(:project)
    Project.base_options.each { |args| option(*args) }
    Project.project_options.each { |args| option(*args) }
    register(Project, "project", "project NAME", "Generates new project")

    long_desc Help.text(:project_test)
    register(Test::Project, "project_test", "project_test NAME", "Generates new project test")

    long_desc Help.text(:module_test)
    register(Test::Module, "module_test", "module_test NAME", "Generates new module test")

    long_desc Help.text(:bootstrap_test)
    Test::Bootstrap.options.each { |args| option(*args) }
    register(Test::Bootstrap, "bootstrap_test", "bootstrap_test", "Generates bootstrap test setup")

    long_desc Help.text(:plugin)
    Plugin.options.each { |args| option(*args) }
    register(Plugin, "plugin", "plugin", "Generates plugin")
  end
end
