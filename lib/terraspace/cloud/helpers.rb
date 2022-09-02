module Terraspace::Cloud
  module Helpers
    def tsc_output(identifier, options={})
      api = Terraspace::Cloud::Api.new(mod: @mod)
      api.tsc_output(identifier, options)
    end
  end
end
