module Terraspace::Compiler::Strategy
  class Mod < AbstractBase
    include Terraspace::Util::Logging

    def run
      klass = strategy_class(@src_path)
      strategy = klass.new(@mod, @src_path) # IE: Terraspace::Compiler::Strategy::Mod::Rb.new
      strategy.run
    end

    def strategy_class(path)
      # Significant speed improvement
      return Mod::Pass if copy_modules?

      ext = File.extname(path).sub('.','')
      return Mod::Pass if ext.empty? # infinite loop without this
      return Mod::Pass if Terraspace.pass_file?(path) or !text_file?(path)
      # Fallback to Mod::Tf for all other files. ERB useful for terraform.tfvars
      "Terraspace::Compiler::Strategy::Mod::#{ext.camelize}".constantize rescue Mod::Pass
    end

    @@copy_modules_warned = false
    def copy_modules?
      return false unless @options[:type_dir] == "modules"

      copy_modules = Terraspace.config.build.copy_modules
      if copy_modules.nil? && @@copy_modules_warned == false
        logger.info "WARN: config.build.copy_modules is not set. Defaulting to true.".color(:yellow)
        logger.info <<~EOL
        The terraspace building behavior is to copy modules from
        the app/modules folder to the .terraspace-cache for speed.
        Most do not need app/modules to be compiled.
        Other files like app/stacks and tfvars files are still compiled.
        This is a change from previous versions of Terraspace, where
        all files were compiled.

        You can turn this warning off by setting:

        .terraspace/config.rb

            Terraspace.configure do |config|
              config.build.copy_modules = true
            end

        In future Terraspace versions, the default will be true.
        There will be no warning message, but it will still be configurable.
        EOL
        copy_modules = true
        @@copy_modules_warned = true
      end

      copy_modules
    end

  private
    def text_file?(filename)
      TextFile.new(filename).check
    end
  end
end
