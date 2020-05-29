module Terraspace::Terraform::Args
  class Default
    def initialize(name, options={})
      @name, @options = name, options
      @quiet = @options[:quiet].nil? ? true : @options[:quiet]
    end

    def args
      if %w[init apply destroy plan output].include?(@name)
        meth = "#{@name}_args"
        send(meth)
      else
        []
      end
    end

    def apply_args
      args = auto_approve_arg
      var_files = @options[:var_files]
      if var_files
        args << var_files.map { |f| "-var-file #{Dir.pwd}/#{f}" }.join(' ')
      end
      args
    end

    def init_args
      args = "-get"
      args << " > /tmp/terraform-init.out" if @quiet && !ENV['TS_INIT_LOUD']
      [args]
    end

    def plan_args
      args = []
      args << "-out #{Dir.pwd}/#{@options[:out]}" if @options[:out]
      args
    end

    def output_args
      args = []
      args << "-json" if @options[:format] == "json"
      args << "> #{Dir.pwd}/#{@options[:out]}" if @options[:out]
      args
    end

    def destroy_args
      auto_approve_arg
    end

    def auto_approve_arg
      @options[:yes] ? ["-auto-approve"] : []
    end
  end
end
