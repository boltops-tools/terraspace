module Terraspace::Terraform::Args
  class Default
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
      when "plan"
        plan_args
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

    def plan_args
      options = []
      options << "-out #{Terraspace.root}/#{@options[:out]}" if @options[:out]
      options
    end

    def output_args
      options = []
      options << "-json" if @options[:format] == "json"
      options << "> #{Terraspace.root}/#{@options[:out]}" if @options[:out]
      options
    end
  end
end
