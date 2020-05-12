module Terraspace::Terraform::Args
  module Dsl
    def command(name, props={})
      @commands[name] = props
    end
  end
end
