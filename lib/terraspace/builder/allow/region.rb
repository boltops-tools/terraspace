class Terraspace::Builder::Allow
  class Region < Base
    # interface method
    def message
      messages = []
      word = config_name.to_s # IE: regions or locations
      messages << "This #{word.singularize} is not allowed to be used: Detected current #{word.singularize}=#{current_region}"
      messages << "Allow #{word}: #{allows.join(', ')}" if allows
      messages << "Deny #{word}: #{denys.join(', ')}" if denys
      messages.join("\n")
    end

    # interface method
    def check_value
      current_region
    end

    def current_region
      expander = Terraspace::Compiler::Expander.autodetect(@mod).expander
      expander.region
    end

    def config_name
      if config.allow.locations || config.deny.locations
        :locations # ActiveSuport::HashWithIndifferentAccess#dig requires symbol
      else
        super # :regions
      end
    end
  end
end
