class Terraspace::Cloud::Ci
  class Vcs
    extend Memoist

    def initialize(vars)
      @vars = vars
    end

    def merged_vars
      vcs_class = case @vars[:host]
                  when /github/ then Github
                  when /gitlab/ then Gitlab
                  when /bitbucket/ then Bitbucket
                  end
      vcs_class ? vcs_class.new(@vars).merged_vars : {}
    end
  end
end
