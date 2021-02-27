module Terraspace::Compiler
  class Select
    def initialize(path)
      @path = path
      @stack_name = extract_stack_name(path)
    end

    def selected?
      !all.ignore_stacks.include?(@stack_name)
    end

    def all
      Terraspace.config.all
    end

    def extract_stack_name(path)
      path.sub(%r{.*(app|vendor)/stacks/}, '')
    end
  end
end
