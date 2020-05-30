module Terraspace::CLI::New::Helper
  module ProviderGem
  private
    def provider_gem_name
      if @options[:provider_gem]
        @options[:provider_gem]
      else
        "terraspace_provider_#{@options[:provider]}"
      end
    end
  end
end
