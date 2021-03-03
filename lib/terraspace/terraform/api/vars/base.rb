class Terraspace::Terraform::Api::Vars
  class Base
    include Terraspace::Util::Logging

    def initialize(mod, vars_path)
      @mod, @vars_path = mod, vars_path
    end
  end
end
