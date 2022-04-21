module Terraspace::Terraform::Ihooks::After
  class Apply < Terraspace::Terraform::Ihooks::Base
    def run
      return unless Terraspace.cloud?
      Terraspace::Cloud::Update.new(@options.merge(stack: @mod.name, kind: "apply")).run
    end
  end
end
