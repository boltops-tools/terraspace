class Terraspace::CLI::New
  class Plugin < Terraspace::Command
    Help = Terraspace::CLI::Help

    long_desc Help.text("new/plugin/ci")
    Ci.options.each { |args| option(*args) }
    register(Ci, "ci", "ci NAME", "Generates CI Plugin.")

    long_desc Help.text("new/plugin/core")
    Core.options.each { |args| option(*args) }
    register(Core, "core", "core NAME", "Generates Core plugin.")
  end
end
