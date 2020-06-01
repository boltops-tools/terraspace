source "https://rubygems.org"

# Specify your gem's dependencies in gemspec
gemspec

gem "rake", "~> 12.0"
gem "rspec", "~> 3.0"

group :development, :test do
  base = ENV['TS_EDGE_ROOT'] || "#{ENV['HOME']}/environment/terraspace-edge"
  gem "terraspace", path: "#{base}/terraspace"
end
