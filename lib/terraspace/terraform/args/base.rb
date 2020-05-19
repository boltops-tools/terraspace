module Terraspace::Terraform::Args
  class Base
    def initialize(name, options={})
      @name, @options = name, options
    end

    def args
      case @name
      when "init"
        ["-get"]
      when "apply", "destroy"
        auto_approve_arg
      else
        []
      end
    end

    def auto_approve_arg
      @options[:yes] ? ["-auto-approve"] : []
    end
  end
end
