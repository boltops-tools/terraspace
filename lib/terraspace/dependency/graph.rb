module Terraspace::Dependency
  class Graph
    include Terraspace::Util::Logging

    attr_reader :nodes
    def initialize(stack_names, dependencies, options={})
      @stack_names, @dependencies, @options = stack_names, dependencies, options
      @nodes = []
      @batches = []
    end

    def build
      precreate_all_nodes
      build_nodes_with_dependencies # @nodes has dependency graph info afterwards
      check_circular_dependencies!
      @nodes = filter_nodes
      check_empty_nodes!
      build_batches
      clean_batches
      @batches
    end

    # Only check when stacks option is pass. Edge case: There can be app/modules but no app/stacks yet
    def check_empty_nodes!
      return unless @nodes.empty? && @options[:stacks]
      logger.error "ERROR: No stacks were found that match: #{@options[:stacks].join(' ')}".color(:red)
      exit 1
    end

    def check_circular_dependencies!
      @nodes.each do |node|
        check_cycle(node)
      end
    end

    MAX_CYCLE_DEPTH = Integer(ENV['TS_MAX_CYCLE_DEPTH'] || 100)
    def check_cycle(node, depth=0, list=[])
      if depth > MAX_CYCLE_DEPTH
        logger.error "ERROR: It seems like there is a circular dependency! Stacks involved: #{list.uniq}".color(:red)
        exit 1
      end
      node.parents.each do |parent|
        check_cycle(parent, depth+1, list += [parent])
      end
    end

    def precreate_all_nodes
      @stack_names.each do |name|
        node = Node.find_or_create_by(name: name)
        save_node(node)
      end
    end

    def build_nodes_with_dependencies
      @dependencies.each do |item|
        parent_name, child_name = item.split(':')

        if Terraspace.config.all.ignore_stacks.include? parent_name
          logger.info("Stack: #{parent_name} skipped due to ignore_stacks configuration")
          next
        end

        save_node_parent(parent_name, child_name)
      end
    end

    def save_node_parent(parent_name, child_name)
      parent = Node.find_by(name: parent_name)
      child = Node.find_by(name: child_name)
      child.parent!(parent)
      save_node(parent)
      save_node(child)
    end

    def build_batches
      @batches[0] = Set.new(leaves)
      leaves.each do |leaf|
        leaf.parents.each do |parent|
          build_batch(parent)
        end
      end
    end

    # So stack nodes dont get deployed more than once and too early
    def clean_batches
      all = Set.new
      # batch is a set
      @batches.reverse.each do |batch|
        batch.each do |node|
          batch.delete(node) if all.include?(node)
        end
        all += batch
      end
      @batches.reject! { |batch| batch.empty? }
      @batches
    end

    def build_batch(leaf, depth=1)
      @batches[depth] ||= Set.new
      @batches[depth] << leaf
      leaf.parents.each do |parent|
        build_batch(parent, depth+1)
      end
    end

    def filter_nodes
      @filtered = []
      top_nodes.each { |node| apply_filter(node) }
      # draw_full_graph option is only used internally by All::Grapher
      update_parents! unless @options[:draw_full_graph]
      @options[:draw_full_graph] ? @nodes : @filtered
    end

    # remove missing parents references since they will be filtered out
    def update_parents!
      @filtered.each do |node|
        new_parents = node.parents & @filtered
        node.parents = new_parents
      end
    end

    def apply_filter(parent, keep=false)
      keep ||= @options[:stacks].blank?
      keep ||= @options[:stacks].include?(parent.name)  # apply filter
      if keep
        parent.filtered = true
        @filtered << parent
      end
      parent.children.sort_by(&:name).each do |child|
        apply_filter(child, keep)
      end
    end

    def leaves
      @nodes.select { |n| n.children.empty? }.sort_by(&:name)
    end

    def top_nodes
      @nodes.select { |n| n.parents.empty? }.sort_by(&:name)
    end

    def save_node(node)
      @nodes << node unless @nodes.detect { |n| n.name == node.name }
    end
  end
end
