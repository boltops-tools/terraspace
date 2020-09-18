class Terraspace::CLI
  class Commander < Base
    def initialize(name, options={})
      @name = name
      super(options)
    end

    def run
      Terraspace::Builder.new(@options).run unless @options[:build] # Up already ran build
      Init.new(@options.merge(calling_command: @name)).run
      Terraspace::Terraform::Runner.new(@name, @options).run
    end
  end
end
