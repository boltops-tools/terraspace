class Terraspace::Cloud::Vcs::LocalGit
  class Base
    extend Memoist

    attr_reader :git_url
    def initialize(vars, git_url)
      @vars, @git_url = vars, git_url
    end

    def vars
      {
        commit_url: commit_url,  # implemented by subclass
        branch_url: branch_url,  # implemented by subclass
        # pr_url handled when PR_NUMBER set by user outside of ci env. ci plugin pr_url takes higher precedence though
        pr_number: pr_number,
        pr_url: pr_url,
      }
    end

    def pr_number
      ENV['TS_VCS_PR_NUMBER'] || ENV['PR_NUMBER'] || ENV['MR_NUMBER']
    end

    class << self
      def vars_methods(*names)
        names.each do |name|
          vars_method(name)
        end
      end

      def vars_method(name)
        define_method name do
          @vars[name]
        end
      end
    end

    vars_methods :host, :full_repo, :sha, :branch_name
  end
end
