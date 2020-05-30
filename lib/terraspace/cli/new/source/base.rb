module Terraspace::CLI::New::Source
  class Base
    include Terraspace::CLI::New::Helper::ProviderGem

    def initialize(sequence, options)
      @sequence, @options = sequence, options
    end

    def set_core_source(template, type)
      template_name = template_name(template, type)
      template_path = File.expand_path("../../../../templates/#{template_name}", __dir__)
      override_source_paths(template_path)
    end

    def require_gem(name)
      begin
        require name # require provider for the templates, this registers the provider
      rescue LoadError => e
        puts "#{e.class}: #{e.message}"
        puts "ERROR: Unable to require provider #{name}.".color(:red)
        puts "Are you sure you the provider exists and you specified the right provider option."
        puts "You specified --provider #{@options[:provider]}"
        exit 1
      end
    end

    def override_source_paths(*paths)
      # https://github.com/erikhuda/thor/blob/34df888d721ecaa8cf0cea97d51dc6c388002742/lib/thor/actions.rb#L128
      @sequence.instance_variable_set(:@source_paths, nil) # unset instance variable cache
      # Using string with instance_eval because block doesnt have access to path at runtime.
      @sequence.class.instance_eval %{
        def self.source_paths
          #{paths.flatten.inspect}
        end
      }
    end
  end
end
