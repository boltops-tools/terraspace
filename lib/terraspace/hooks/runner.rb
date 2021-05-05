module Terraspace::Hooks
  class Runner
    include Terraspace::Util

    # exposing mod and hook so terraspace hooks have access to them via runner context. IE:
    #
    #     class EnvExporter
    #       def call(runner)
    #         puts "runner.hook #{runner.hook}"
    #       end
    #     end
    #
    # Docs: http://terraspace.cloud/docs/config/hooks/ruby/#method-argument
    #
    attr_reader :mod, :hook
    def initialize(mod, hook)
      @mod, @hook = mod, hook
      @execute = @hook["execute"]
    end

    def run
      case @execute
      when String
        Terraspace::Shell.new(@mod, @execute, exit_on_fail: @hook["exit_on_fail"]).run
      when -> (e) { e.respond_to?(:public_instance_methods) && e.public_instance_methods.include?(:call) }
        executor = @execute.new
      when -> (e) { e.respond_to?(:call) }
        executor = @execute
      else
        logger.warn "WARN: execute option not set for hook: #{@hook.inspect}"
      end

      if executor
        meth = executor.method(:call)
        case meth.arity
        when 0
          executor.call # backwards compatibility
        when 1
          executor.call(self)
        else
          raise "The #{executor} call method definition has been more than 1 arguments and is not supported"
        end
      end
    end
  end
end
