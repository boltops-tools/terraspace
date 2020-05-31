source "https://rubygems.org"

# Specify your gem dependencies in terraspace.gemspec
gemspec

gem "codeclimate-test-reporter", group: :test, require: nil

if ENV['TS_EDGE']
  base = ENV['TS_EDGE_ROOT'] || "#{ENV['HOME']}/environment/terraspace-edge"
  gem "terraspace_plugin_aws", path: "#{base}/terraspace_plugin_aws"
  gem "terraspace_plugin_google", path: "#{base}/terraspace_plugin_google"
else
  gem "terraspace_plugin_aws"
  gem "terraspace_plugin_google"
end
