class Terraspace::Cloud::Vcs
  module Interface
    extend Memoist
    include Terraspace::Util::Logging

    MARKER = "<!-- terraspace marker -->"

    attr_reader :full_repo, :pr_number
    def initialize(options={})
      @full_repo = options[:full_repo]
      @pr_number = options[:pr_number]
    end
  end
end
