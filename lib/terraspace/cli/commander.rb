class Terraspace::CLI
  class Commander < Base
    def initialize(name, options={})
      @name = name
      super(options)
    end

    # Commander always runs Build#run
    def run
      Terraspace::Builder.new(@options).run # generate and init
      auto_create_backend
      Init.new(@options.merge(calling_command: @name)).run
      Terraspace::Terraform::Runner.new(@name, @options).run
    end

    def auto_create_backend
      return unless @name == "apply"
      Terraspace::Compiler::Backend.new(@mod).create
    end
  end
end
