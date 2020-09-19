module Terraspace::Compiler
  module CommandsConcern
    def requires_backend?
      command_is?(requires_backend_commands)
    end

    def requires_backend_commands
      %w[down init output plan providers refresh show up validate]
    end

    def command_is?(*commands)
      commands.flatten!
      commands.map!(&:to_s)
      commands.include?(ARGV[0]) ||                  # IE: terraspace up
      ARGV[0] == "all" && commands.include?(ARGV[1]) # IE: terraspace all up
    end
  end
end
