module Terraspace::Compiler
  module HelperExtender
  private
    def extend_module_level_helpers
      full_dir = "#{@mod.root}/config/helpers"
      Dir.glob("#{full_dir}/**/*").each do |path|
        regexp = Regexp.new(".*/helpers/")
        klass = path.sub(regexp, '').sub('.rb','').camelcase
        klass = "#{mod_namespace}::#{klass}"
        require path # able to use require instead of load since each helper has unique namespace
        send :extend, klass.constantize
      end
    end

    # IE: mod_namespace = Terraspace::Module::Demo
    # Use separate namespaces scope with module name so custom helper methods from different modules are isolated.
    def mod_namespace
      mod_name = @mod.name.camelcase
      ns = "Terraspace::#{@mod.type.camelcase}".constantize # IE: Terraspace::Module or Terraspace::Stack
      if ns.const_defined?(mod_name.to_sym)
        "#{ns}::#{mod_name}".constantize
      else
        ns.const_set(mod_name, Module.new)
      end
    end
  end
end
