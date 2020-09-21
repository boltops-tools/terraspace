module Terraspace::Compiler::Dsl::Syntax::Helpers
  module Common
    extend Memoist
    Meta = Terraspace::Compiler::Dsl::Meta

    def var
      Meta::Var.new
    end
    memoize :var

    def local
      Meta::Local.new
    end
    memoize :local

    # Only show the first 2 args and now the options. Examples:
    #
    #     terraspace_command => "terraspace up demo"
    #     terraspace_command('-') => "terraspace-up-demo"
    #
    def terraspace_command(separator=' ')
      args = ARGV[0..1] || []
      command = ["terraspace"] + args
      command.join(separator)
    end
  end
end
