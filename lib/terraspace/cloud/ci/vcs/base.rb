class Terraspace::Cloud::Ci::Vcs
  class Base
    extend Memoist

    def initialize(vars)
      @vars = vars
    end

    def vars
      {
        commit_url: commit_url,  # implemented by subclass
        branch_url: branch_url,  # implemented by subclass
      }
    end

    def merged_vars
      @vars.merge(vars)
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
