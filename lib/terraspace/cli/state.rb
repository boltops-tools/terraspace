class Terraspace::CLI
  class State < Base
    def run
      @name = "state #{@options[:subcommand]}" # command name. IE: state list
      Terraspace::Builder.new(@options).run
      Init.new(@options).run
      Terraspace::Terraform::Runner.new(@name, @options).run
    end
  end
end
