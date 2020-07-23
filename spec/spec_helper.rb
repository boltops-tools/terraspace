ENV["TS_TEST"] = "1"

# CodeClimate test coverage: https://docs.codeclimate.com/docs/configuring-test-coverage
# require 'simplecov'
# SimpleCov.start

require "pp"
require "byebug"
root = File.expand_path("../", File.dirname(__FILE__))

# require plugins so Terraspace::Plugin.meta is populated
require "terraspace_plugin_aws"
require "terraspace_plugin_azurerm"
require "terraspace_plugin_google"
require "#{root}/lib/terraspace"

module Helper
  def execute(cmd)
    puts "Running: #{cmd}" if ENV['SHOW_COMMAND']
    out = `#{cmd}`
    puts out if ENV['SHOW_COMMAND']
    out
  end

  def fixture(path)
    "spec/fixtures/#{path}"
  end
end

RSpec.configure do |c|
  c.include Helper
end
