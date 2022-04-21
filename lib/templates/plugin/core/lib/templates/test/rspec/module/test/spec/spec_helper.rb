ENV["TS_ENV"] = "test"

require "terraspace"
require "rspec/terraspace"

module Helper
  # Add your helpers here
end

RSpec.configure do |c|
  c.include RSpec::Terraspace::Helpers
  c.include Helper
end
