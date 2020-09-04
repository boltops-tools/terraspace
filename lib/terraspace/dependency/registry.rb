module Terraspace::Dependency
  class Registry
    cattr_accessor :data, default: Set.new

    class << self
      def register(parent_name, child_name)
        @@data << "#{parent_name}:#{child_name}"
      end
    end
  end
end
