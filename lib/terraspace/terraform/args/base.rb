module Terraspace::Terraform::Args
  class Base
    def initialize(name, options={})
      @name, @options = name, options
      @quiet = @options[:quiet].nil? ? true : @options[:quiet]
    end

    def args
      case @name
      when "init"
        init_args
      when "apply", "destroy"
        auto_approve_arg
      when "output"
        output_args
      else
        []
      end
    end

    def init_args
      args = "-get"
      args << " > /dev/null" if @quiet && !ENV['TS_INIT_LOUD']
      [args]
    end

    def auto_approve_arg
      @options[:yes] ? ["-auto-approve"] : []
    end

    def output_args
      options = []
      options << "-json" if @options[:json]
      options << "> #{@options[:out]}" if @options[:out]
      options
    end
  end
end
