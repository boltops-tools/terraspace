require "thor"

# Usage:
#
#    @actions = Actions.new
#    @actions.create_file("content", "/path/to/file.txt")
#
class Terraspace::Seeder
  class Actions
    # What's needed for a Thor::Group or "Sequence"
    # Gives us Thor::Actions commands like create_file
    include Thor::Actions
    include Thor::Base

    attr_reader :options # Thor requires options
    # Override Thor::Base initialize to set destination_root
    def initialize(options={})
      # Thor::Base.initialize(args = [], local_options = {}, config = {}) <= original signature
      options[:force] = options[:yes]
      super([], options)
      self.destination_root = Dir.pwd # Thor::Actions require destination_root to be set
    end
  end
end
