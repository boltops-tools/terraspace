module Terraspace::Compiler
  module CommandsConcern
    def command_is?(*commands)
      commands.flatten!
      commands.map!(&:to_s)
      commands.include?(Terraspace.argv[0]) ||                  # IE: terraspace up
      Terraspace.argv[0] == "all" && commands.include?(Terraspace.argv[1]) # IE: terraspace all up
    end
  end
end
