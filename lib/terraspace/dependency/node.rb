module Terraspace::Dependency
  class Node
    attr_reader :name
    attr_accessor :children, :parents, :filtered
    def initialize(name)
      @name = name
      @children, @parents = Set.new, Set.new
    end

    def highlighted?
      @filtered
    end

    def inspect
      @name
    end

    def parent!(parent)
      @parents << parent
      parent.children << self
    end

    class << self
      @@nodes = []
      def find_or_create_by(name:)
        node = find_by(name: name)
        return node if node
        node = Node.new(name)
        @@nodes << node
        node
      end

      def find_by(name:)
        @@nodes.find { |n| n.name == name }
      end
    end
  end
end
