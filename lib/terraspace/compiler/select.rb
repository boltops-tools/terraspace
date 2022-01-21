module Terraspace::Compiler
  class Select
    include Terraspace::Util::Logging

    def initialize(path)
      @path = path
      @stack_name = extract_stack_name(path)
    end

    def selected?
      ignore_stacks_deprecation_warning
      if include_stacks.nil? && exclude_stacks.nil?
        true
      elsif include_stacks.nil?
        !exclude_stacks.include?(@stack_name)
      elsif exclude_stacks.nil?
        include_stacks.include?(@stack_name)
      else
        stacks = include_stacks - exclude_stacks
        stacks.include?(@stack_name)
      end
    end

    def include_stacks
      include_option(:include_stacks)
    end

    def exclude_stacks
      include_option(:exclude_stacks)
    end

    def include_option(name)
      option = all[name]  # IE: include_stacks or exclude_stacks
      option ||= all[:ignore_stacks] if name == :exclude_stacks
      case option
      when nil
        return nil
      when Array
        return option
      when -> (c) { c.respond_to?(:public_instance_methods) && c.public_instance_methods.include?(:call) }
        object= option.new
      when -> (c) { c.respond_to?(:call) }
        object = option
      else
        raise "Invalid option for config.all.#{name}"
      end

      if object
        result = object.call(@stack_name)
        unless result.is_a?(Array) || result.is_a?(NilClass)
          message = "ERROR: The config.all.#{name} needs to return an Array or nil"
          logger.info message.color(:yellow)
          logger.info <<~EOL
            The config.all.#{name} when assigned a class, object, or proc must implement
            the call method and return an Array or nil.
            The current return value is a #{result.class}
          EOL
          raise message
        end
      end
      result
    end

  private
    def all
      Terraspace.config.all
    end

    def extract_stack_name(path)
      path.sub(%r{.*(app|vendor)/stacks/}, '')
    end

    @@ignore_stacks_deprecation_warning = nil
    def ignore_stacks_deprecation_warning
      return unless all.ignore_stacks
      return if @@ignore_stacks_deprecation_warning
      puts <<~EOL.color(:yellow)
        DEPRECATED:  config.all.ignore_stacks
        Instead use: config.all.exclude_stacks
      EOL
      @@ignore_stacks_deprecation_warning = true
    end
  end
end
