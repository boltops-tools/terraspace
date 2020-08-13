class Terraspace::Terraform::Api::Vars
  class Rb < Base
    include DslEvaluator

    def initialize(*)
      super
      @vars = [] # holds results
    end

    def vars
      evaluate_file(@vars_path)
      @vars
    end

    def var(attrs={})
      default = { category: "terraform" } # required field
      var = default.deep_merge(attrs).deep_stringify_keys!
      @vars << var
    end
  end
end
