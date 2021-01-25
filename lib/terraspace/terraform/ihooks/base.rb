module Terraspace::Terraform::Ihooks
  class Base < Terraspace::CLI::Base
    def initialize(name, options={})
      @name = name
      super(options)
    end
  end
end
