source "https://rubygems.org"

# Specify your gem dependencies in terraspace.gemspec
gemspec

gem "codeclimate-test-reporter", group: :test, require: nil

if ENV['TS_EDGE']
  base = ENV['TS_BASE_FOLDER'] || "#{ENV['HOME']}/environment"
  gem "terraspace_provider_aws", path: "#{base}/terraspace_provider_aws"
  gem "terraspace_provider_gcp", path: "#{base}/terraspace_provider_gcp"
end
