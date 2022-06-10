module Terraspace::Terraform::Ihooks
  class Base < Terraspace::CLI::Base
    include Terraspace::Cloud::Api::Concern

    def initialize(name, options={})
      @name = name
      @success = options[:success]
      super(options)
    end

    def destroy?
      return false if @options.nil?
      result = @options[:args]&.include?('--destroy') || @options[:destroy]
      !!result
    end
  end
end
