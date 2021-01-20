class Terraspace::CLI
  class State < Terraspace::Command
    class_option :yes, aliases: :y, type: :boolean, desc: "auto approve all batch commands"
    class_option :exit_on_fail, type: :boolean, desc: "whether or not to exit when one of the batch commands fails"

    desc "import STACK RESOURCE ID", "Use terraform to import a resource to this stacks statefile."
    long_desc Help.text("all/import")
    def import(stack, resouce, identifier)
      Terraspace::Import::Runner.new("import", @options.merge(
        stack: stack,
        resource: resource,
        identifier: identifier
      )).run
    end
  end
end
