module Terraspace::Compiler
  class Select
    def initialize(path)
      @path = path
      @stack_name = extract_stack_name(path)
    end

    def selected?
      all = Terraspace.config.all
      # Key difference between include_stacks vs all.include_stacks option is that
      # the option can be nil. The local variable is guaranteed to be an Array.
      # This simplifies the logic.
      include_stacks = all.include_stacks || []
      ignore_stacks  = all.ignore_stacks  || []

      if all.include_stacks.nil?
        !ignore_stacks.include?(@stack_name)
      else
        stacks = include_stacks - ignore_stacks
        stacks.include?(@stack_name)
      end
    end

    def extract_stack_name(path)
      path.sub(%r{.*(app|vendor)/stacks/}, '')
    end
  end
end
