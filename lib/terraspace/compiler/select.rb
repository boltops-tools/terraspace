module Terraspace::Compiler
  class Select
    include Terraspace::App::CallableOption::Concern
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
      if config.all.include_stacks
        config_name = "config.all.include_stacks"
        config_value = config.dig(:all, :include_stacks)
      elsif config.all.consider_allow_deny_stacks
        config_name = "config.allow.stacks"
        config_value = config.dig(:allow, :stacks)
      else
        return
      end
      callable_option(
        config_name: config_name,
        config_value: config_value,
        passed_args: [@stack_name],
      )
    end

    def exclude_stacks
      if config.all.exclude_stacks
        config_name = "config.all.exclude_stacks"
        config_value = config.dig(:all, :exclude_stacks)
      elsif config.all.consider_allow_deny_stacks
        config_name = "config.deny.stacks"
        config_value = config.dig(:deny, :stacks)
      else
        return
      end
      callable_option(
        config_name: config_name,
        config_value: config_value,
        passed_args: [@stack_name],
      )
    end

  private
    def config
      Terraspace.config
    end

    def extract_stack_name(path)
      path.sub(%r{.*(app|vendor)/stacks/}, '')
    end

    @@ignore_stacks_deprecation_warning = nil
    def ignore_stacks_deprecation_warning
      return unless config.all.ignore_stacks
      return if @@ignore_stacks_deprecation_warning
      puts <<~EOL.color(:yellow)
        DEPRECATED:  config.all.ignore_stacks
        Instead use: config.all.exclude_stacks
      EOL
      @@ignore_stacks_deprecation_warning = true
    end
  end
end
