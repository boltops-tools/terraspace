module Terraspace::Tester
  class Finder
    def find_with(options)
      result = if options.key?(:framework)
                 find_with_framework(options[:framework])
               else
                 raise "Must provide framework_name option."
               end

      return unless result
      raw = Hash[*result] # convert result to Hash instead of an Array
      Meta.new(raw)
    end

    def find_with_framework(framework)
      meta.find do |framework_name, data|
        framework_name == framework
      end
    end

    def meta
      Terraspace::Tester.meta
    end
  end
end
