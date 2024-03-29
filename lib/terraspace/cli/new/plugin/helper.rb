class Terraspace::CLI::New::Plugin
  module Helper
  private
    def gem_class_name
      gem_name.camelize
    end

    def camel_name
      name.camelize
    end

    # friendly method
    def core_template_source(template)
      source = Terraspace::CLI::New::Source::Core.new(self, @options)
      source.set_core_source(template)
    end
  end
end
