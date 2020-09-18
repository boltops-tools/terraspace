module Terraspace::Terraform::RemoteState::Marker
  class Output
    include Terraspace::Util::Logging

    def initialize(mod, identifier, options={})
      @mod, @identifier, @options = mod, identifier, options
      @parent_name = @mod.name
      @child_name, @output_key = @identifier.split('.')
    end

    def build
      if valid?
        Terraspace::Dependency::Registry.register(@parent_name, @child_name)
      else
        warning
      end
      # MARKER for debugging. Only appears on 1st pass. Will not see unless changing Terraspace code for debugging.
      marker = "MARKER:terraform_output('#{@identifier}')"
      Terraspace::Terraform::RemoteState::OutputProxy.new(marker, @options)
    end

    def valid?
      self.class.stack_names.include?(@child_name)
    end

    def warning
      logger.warn "WARN: The #{@child_name} stack does not exist".color(:yellow)
      caller_line = caller.find { |l| l.include?('.tfvars') }
      source_code = PrettyTracer.new(caller_line).source_code
      logger.info source_code
    end

    class << self
      extend Memoist
      # Marker::Output uses DirsConcern stack_names to check if stacks are valid
      include Terraspace::Compiler::DirsConcern
    end
  end
end
