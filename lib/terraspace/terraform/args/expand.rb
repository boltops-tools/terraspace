module Terraspace::Terraform::Args
  class Expand
    class << self
      def option_method(*names)
        names.compact.each do |name|
          option_method_each(name)
        end
      end

      def option_method_each(name)
        define_method name do
          return unless @options[name]
          expander = Terraspace::Compiler::Expander.autodetect(@mod)
          expander.expansion(@options[name]) # pattern is a String that contains placeholders for substitutions
        end
      end
    end

    def initialize(mod, options={})
      @mod, @options = mod, options
    end

    option_method :plan, :out
  end
end
