class Terraspace::CLI
  class Commander < Base
    def initialize(name, options={})
      @name = name
      super(options)
    end

    def run
      Terraspace::Builder.new(@options).run unless @options[:build] # Up already ran build
      auto_create_backend
      Init.new(@options.merge(calling_command: @name)).run
      Terraspace::Terraform::Runner.new(@name, @options).run
    end

    def auto_create_backend
      return unless auto_create?
      Terraspace::Compiler::Backend.new(@mod).create
    end

    def auto_create?
      @name == "apply" || @name == "plan" && @options[:yes]
    end
  end
end
