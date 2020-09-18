module Terraspace::Compiler::Dsl::Syntax::Helpers
  module Common
    extend Memoist
    Fetcher = Terraspace::Terraform::RemoteState::Fetcher
    Marker = Terraspace::Terraform::RemoteState::Marker
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

    def terraform_output(identifier, options={})
      if @mod.resolved # dependencies have been resolved
        Fetcher.new(@mod, identifier, options).output
      else
        Marker::Output.new(@mod, identifier, options).build
      end
    end

    def depends_on(*child_names, **options)
      child_names.flatten!
      child_names.map do |child_name|
        each_depends_on(child_name, options)
      end.join("\n")
    end

    def each_depends_on(child_name, options={})
      if @mod.resolved # dependencies have been resolved
        # Note: A generated line is not really needed. Dependencies are stored in memory. Added to assist users with debugging
        "# #{@mod.name} depends on #{child_name}"
      else
        Marker::Output.new(@mod, child_name, options).build
      end
    end
  end
end
