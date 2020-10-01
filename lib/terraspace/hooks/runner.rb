module Terraspace::Hooks
  class Runner
    include Terraspace::Util

    def initialize(mod, hook)
      @mod, @hook = mod, hook
      @execute = @hook["execute"]
    end

    def run
      case @execute
      when String
        Terraspace::Shell.new(@mod, @execute, exit_on_fail: @hook["exit_on_fail"]).run
      when -> (e) { e.respond_to?(:public_instance_methods) && e.public_instance_methods.include?(:call) }
        @execute.new.call
      when -> (e) { e.respond_to?(:call) }
        @execute.call
      else
        logger.warn "WARN: execute option not set for hook: #{@hook.inspect}"
      end
    end
  end
end
