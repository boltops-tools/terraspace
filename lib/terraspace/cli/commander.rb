class Terraspace::CLI
  class Commander < Base
    def initialize(name, options={})
      @name = name
      super(options)
    end

    # Commander always runs Build#run
    def run
      Build.new(@options).run # generate and init
      Terraspace::Terraform::Runner.new(@name, @options).run
    end
  end
end
