module Terraspace::Terraform::Ihooks::Before
  class Apply < Terraspace::Terraform::Ihooks::Base
    def run
      return unless Terraspace.cloud?
      Terraspace::Cloud::Update.new(@options.merge(stack: @mod.name, kind: "apply")).cani?
    end
  end
end
