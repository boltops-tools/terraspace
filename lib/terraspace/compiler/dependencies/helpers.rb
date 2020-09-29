module Terraspace::Compiler::Dependencies
  # This is a separate module specifically because the DSL also has an output method.
  # The module allows us to include dependency related methods only within tfvars context for the DSL.
  #
  #     1. Only include this module to DSL tfvars context.
  #        So the output method works in tfvars .rb files works.
  #        At the same time, the DSL usage of output also works for normal main.tf files.
  #        Passing specs prove this.
  #     2. For ERB, there's currently only one ERB context. So this module is included in all contexts.
  #        The builder only processes dependencies from tfvars, so these helpers are only respected there.
  #
  # Where the module is included in the code:
  #
  #     1. lib/terraspace/compiler/dsl/syntax/tfvar.rb
  #     2. lib/terraspace/compiler/erb/helpers.rb
  #
  module Helpers
    def output(identifier, options={})
      Terraspace::Dependency::Helper::Output.new(@mod, identifier, options).result
    end
    alias_method :terraform_output, :output # backwards compatibility

    def depends_on(*child_names, **options)
      child_names.flatten!
      child_names.map do |child_name|
        each_depends_on(child_name, options)
      end.join("\n")
    end

    def each_depends_on(child_name, options={})
      Terraspace::Dependency::Helper::DependsOn.new(@mod, child_name, options).result
    end
  end
end
