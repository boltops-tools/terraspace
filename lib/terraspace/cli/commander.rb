class Terraspace::CLI
  class Commander < Base
    def initialize(name, options={})
      @name = name
      super(options)
    end

    def run
      Terraspace::Builder.new(@options).run unless @options[:build] # Up already ran build
      Init.new(@options).run
      @runner = Terraspace::Terraform::Runner.new(@name, @options)
      success = @runner.run
      exit 1 unless success
    end
  end
end
