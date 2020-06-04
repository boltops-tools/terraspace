module Terraspace::Terraform::Args
  module Dsl
    include Shorthands

    def command(*commands, **props)
      commands.each do |name|
        if name.is_a?(Symbol)
          shorthand_commands(name, props)
        else
          each_command(name, props)
        end
      end
    end
    alias_method :commands, :command

    def shorthand_commands(name, props)
      shorthands[name].each do |n|
        each_command(n, props)
      end
    end

    def each_command(name, props={})
      @commands[name] = props
    end
  end
end
