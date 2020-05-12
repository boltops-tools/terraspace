module Terraspace::Terraform::Args
  module Dsl
    def command(*commands, **props)
      commands.each do |name|
        each_command(name, props)
      end
    end

    def each_command(name, props={})
      @commands[name] = props
    end
  end
end
