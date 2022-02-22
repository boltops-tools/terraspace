class Terraspace::Builder
  class Children
    include Terraspace::Util::Logging

    def initialize(mod, options={})
      @mod, @options = mod, options
      @queue = []
    end

    def build
      # Find out if current deploy stack contains dependency
      dependencies = Terraspace::Dependency::Registry.data
      root = dependencies.find do |parent_child|
        parent, _ = parent_child.split(':')
        parent == @mod.name
      end
      return unless root

      # Go down dependency graph to build a queue for processing
      name, _ = root.split(':')
      node = Terraspace::Dependency::Node.find_by(name: name)
      build_queue(node)
      logger.debug "Terraspace::Builder::Children @queue #{@queue}"

      # Process queue in reverse order to build leaf nodes first
      @queue.reverse.each do |node|
        mod = Terraspace::Mod.new(node.name, @options)
        Terraspace::Compiler::Perform.new(mod).compile
      end
    end

    # Use depth first traversal to build queue
    def build_queue(node)
      node.children.each do |child|
        @queue << child
        build_queue(child)
      end
      @queue
    end
  end
end
