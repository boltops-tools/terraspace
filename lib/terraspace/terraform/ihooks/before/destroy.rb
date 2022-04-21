module Terraspace::Terraform::Ihooks::Before
  class Destroy < Terraspace::Terraform::Ihooks::Base
    def run
      return unless Terraspace.cloud?
      Terraspace::Cloud::Update.new(@options.merge(stack: @mod.name, kind: "destroy")).cani?
    end
  end
end
