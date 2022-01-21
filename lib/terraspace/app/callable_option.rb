# Class represents a terraspace option that is possibly callable. Examples:
#
#    config.allow.envs
#    config.allow.regions
#    config.deny.envs
#    config.deny.regions
#    config.all.include_stacks
#    config.all.exclude_stacks
#
# Abstraction is definitely obtuse. Using it to get rid of duplication.
#
class Terraspace::App
  class CallableOption
    include Terraspace::Util::Logging

    def initialize(options={})
      @options = options
      # Example:
      # config_name:  config.allow.envs
      # config_value: ["dev"]
      # args:         [@stack_name] # passed to object.call
      @config_name = options[:config_name]
      @config_value = options[:config_value]
      @passed_args = options[:passed_args]
    end

    # Returns either an Array or nil
    def object
      case @config_value
      when nil
        return nil
      when Array
        return @config_value
      when -> (c) { c.respond_to?(:public_instance_methods) && c.public_instance_methods.include?(:call) }
        object= @config_value.new
      when -> (c) { c.respond_to?(:call) }
        object = @config_value
      else
        raise "Invalid option for #{@config_name}"
      end

      if object
        result = @passed_args.empty? ? object.call : object.call(*@passed_args)
        unless result.is_a?(Array) || result.is_a?(NilClass)
          message = "ERROR: The #{@config_name} needs to return an Array or nil"
          logger.info message.color(:yellow)
          logger.info <<~EOL
            The #{@config_name} when assigned a class, object, or proc must implement
            the call method and return an Array or nil.
            The current return value is a #{result.class}
          EOL
          raise message
        end
      end
      result
    end
  end
end
