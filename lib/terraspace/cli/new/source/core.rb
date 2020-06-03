module Terraspace::CLI::New::Source
  class Core
    include Terraspace::CLI::New::Helper::PluginGem

    def initialize(sequence, options)
      @sequence, @options = sequence, options
    end

    def set_core_source(template, type=nil)
      template_name = template_name(template, type)
      template_path = File.expand_path("../../../../templates/#{template_name}", __dir__)
      override_source_paths(template_path)
    end

    def template_name(template, type=nil)
      [template, type].compact.join('/')
    end

    def require_gem(name)
      begin
        require name # require plugin for the templates, this registers the plugin
      rescue LoadError => e
        puts "#{e.class}: #{e.message}".color(:red)
        logger.error "ERROR: Unable to require plugin #{name}.".color(:red)
        puts "Are you sure you the plugin exists and you specified the right plugin option."
        puts "You specified --plugin #{@options[:plugin]}"
        exit 1
      end
    end

    def set_plugin_gem_source(template, type)
      require_gem(plugin_gem_name)
      plugin = Terraspace::Plugin.find_with(plugin: @options[:plugin])
      template_name = template_name(template, type)
      template_path = File.expand_path("#{plugin.root}/lib/templates/#{template_name}")
      override_source_paths(template_path)
    end

    def template_name(template, type)
      if template == "test"
        "#{template}/#{Terraspace.config.test_framework}/#{type}"
      else
        "#{template}/#{type}"       # IE: hcl/module
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
