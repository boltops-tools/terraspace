class Terraspace::CLI
  class New < Terraspace::Command
    long_desc Help.text("new/arg")
    Arg.options.each { |args| option(*args) }
    register(Arg, "arg", "arg NAME", "Generates new arg.")

    long_desc Help.text("new/git_hook")
    GitHook.cli_options.each { |args| option(*args) }
    register(GitHook, "git_hook", "git_hook", "Generates new git hook.")

    long_desc Help.text("new/shim")
    Shim.cli_options.each { |args| option(*args) }
    register(Shim, "shim", "shim", "Generates terraspace shim.")

    long_desc Help.text("new/helper")
    Helper.options.each { |args| option(*args) }
    register(Helper, "helper", "helper NAME", "Generates new helper.")

    long_desc Help.text("new/hook")
    Hook.options.each { |args| option(*args) }
    register(Hook, "hook", "hook NAME", "Generates new hook.")

    long_desc Help.text("new/module")
    Module.base_options.each { |args| option(*args) }
    Module.component_options.each { |args| option(*args) }
    register(Module, "module", "module NAME", "Generates new module.")

    long_desc Help.text("new/project")
    Project.base_options.each { |args| option(*args) }
    Project.project_options.each { |args| option(*args) }
    register(Project, "project", "project NAME", "Generates new project.")

    long_desc Help.text("new/plugin")
    Plugin.options.each { |args| option(*args) }
    register(Plugin, "plugin", "plugin NAME", "Generates plugin.")

    long_desc Help.text("new/stack")
    Stack.base_options.each { |args| option(*args) }
    Stack.component_options.each { |args| option(*args) }
    register(Stack, "stack", "stack NAME", "Generates new stack.")

    long_desc Help.text("new/test")
    Test.options.each { |args| option(*args) }
    register(Test, "test", "test NAME", "Generates new test.")

    long_desc Help.text("new/example")
    register(Example, "example", "example [NAME]", "Generates new example.")
  end
end
