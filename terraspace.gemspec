# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "terraspace/version"

Gem::Specification.new do |spec|
  spec.name          = "terraspace"
  spec.version       = Terraspace::VERSION
  spec.authors       = ["Tung Nguyen"]
  spec.email         = ["tung@boltops.com"]
  spec.summary       = "Terraspace: The Terraspace Framework"
  spec.homepage      = "https://github.com/boltops-tools/terraspace"
  spec.license       = "Apache-2.0"

  spec.files         = File.directory?('.git') ? `git ls-files`.split($/) : Dir.glob("**/*")
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "cli-format"
  spec.add_dependency "dsl_evaluator"
  spec.add_dependency "hcl_parser"
  spec.add_dependency "memoist"
  spec.add_dependency "rainbow"
  spec.add_dependency "render_me_pretty"
  spec.add_dependency "terraspace-bundler"
  spec.add_dependency "thor"
  spec.add_dependency "zeitwerk"

  # core baseline plugins
  spec.add_dependency "terraspace_plugin_aws"
  spec.add_dependency "terraspace_plugin_azurerm"
  spec.add_dependency "terraspace_plugin_google"
  spec.add_dependency "rspec-terraspace"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "cli_markdown"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
