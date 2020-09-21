module Terraspace::All
  class Preview
    extend Memoist
    include Terraspace::Util::Logging
    include Terraspace::Compiler::DirsConcern

    def initialize(command, batches, options={})
      @command, @batches, @options = command, batches, options
    end

    def show
      logger.info header
      logger.info preview
    end

    def header
      %w[up down].include?(@command) && !@options[:yes] ? "Will run:" : "Running:"
    end

    def preview
      i = 0
      @batches.map do |batch|
        i += 1
        batch.map do |stack|
          command = "    terraspace #{@command}"
          ljust = command.size + max_name_size + 1
          command = "#{command} #{stack.name}"
          command.ljust(ljust, ' ') + " # batch #{i}"
        end
      end.join("\n")
    end

    def max_name_size
      @batches.inject(0) do |max,batch|
        batch.each do |node|
          max = node.name.size if node.name.size > max
        end
        max
      end
    end
    memoize :max_name_size
  end
end
