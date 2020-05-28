module Terraspace::Provider
  class Finder
    def initialize(options={})
      @options = options
    end

    def find
      result = if @options.key?(:backend)
                  find_with_backend(@options[:backend])
                elsif @options.key?(:provider)
                  find_with_provider(@options[:provider])
                else
                  raise "Must provide backend or provider option."
                end
      raw = Hash[*result] # convert result to Hash instead of an Array
      Meta.new(raw)
    end

    def find_with_backend(backend)
      meta.find do |provider, data|
        data[:backend] == backend
      end
    end

    def find_with_provider(provider)
      meta.find do |provider_name, data|
        provider_name == provider
      end
    end

    def meta
      Terraspace::Provider.meta
    end
  end
end
