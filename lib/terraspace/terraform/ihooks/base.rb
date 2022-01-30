module Terraspace::Terraform::Ihooks
  class Base < Terraspace::CLI::Base
    def initialize(name, options={})
      @name = name
      super(options)
    end

    def out_option
      expand = Terraspace::Terraform::Args::Expand.new(@mod, @options)
      expand.out
    end
  end
end
