module Terraspace::Dependency
  class Resolver
    include Terraspace::Compiler::DirsConcern

    def initialize(options={})
      @options = options
    end

    def resolve
      with_each_mod("stacks") do |mod|
        Terraspace::Compiler::Perform.new(mod).compile_tfvars(write: false)
      end

      dependencies = Terraspace::Dependency::Registry.data # populated dependencies resolved
      @graph = Terraspace::Dependency::Graph.new(stack_names, dependencies, @options)
      @graph.build # Returns batches to run
    end
  end
end
