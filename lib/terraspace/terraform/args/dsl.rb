module Terraspace::Terraform::Args
  module Dsl
    include Shorthands

    def command(*commands, **props)
      commands.each do |name|
        if shorthand?(name)
          shorthand_commands(name, props)
        else
          each_command(name, props)
        end
      end
    end
    alias_method :commands, :command

    def shorthand?(name)
      shorthands.key?(name.to_sym)
    end

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
