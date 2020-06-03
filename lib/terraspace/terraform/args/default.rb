module Terraspace::Terraform::Args
  class Default
    def initialize(mod, name, options={})
      @mod, @name, @options = mod, name, options
      @quiet = @options[:quiet].nil? ? true : @options[:quiet]
    end

    def args
      # https://terraspace.cloud/docs/ci-automation/
      ENV['TF_IN_AUTOMATION'] = '1' if @options[:auto]

      if %w[apply destroy init output plan].include?(@name)
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

      if @options[:auto] && @options[:input].nil?
        args << " -input=false"
      end
      unless @options[:input].nil?
        input = @options[:input] ? "true" : "false"
        args << " -input=#{input}" # = sign required for apply when there's a plan at the end. so input=false works input false doesnt
      end

      # must be at the end
      plan = @options[:plan]
      if plan
        if plan.starts_with?('/')
          src  = plan
          dest = src
        else
          src = "#{Dir.pwd}/#{plan}"
          dest = "#{@mod.cache_build_dir}/#{File.basename(src)}"
        end
        FileUtils.cp(src, dest)
        args << " #{dest}"
      end
      args
    end

    def init_args
      args = "-get"
      if @options[:auto] && @options[:input].nil?
        args << " -input=false"
      end
      unless @options[:input].nil?
        input = @options[:input] ? "true" : "false"
        args << " -input=#{input}"
      end

      # must be at the end
      if @quiet && !ENV['TS_INIT_LOUD']
        out_path = "#{Terraspace.tmp_root}/out/terraform-init.out"
        FileUtils.mkdir_p(File.dirname(out_path))
        args << " > #{out_path}"
      end
      [args]
    end

    def plan_args
      args = []
      args << "-out #{expanded_out}" if @options[:out]
      args
    end

    def output_args
      args = []
      args << "-json" if @options[:format] == "json"
      args << "> #{expanded_out}" if @options[:out]
      args
    end

    def expanded_out
      out = @options[:out]
      out.starts_with?('/') ? out : "#{Dir.pwd}/#{out}"
    end

    def destroy_args
      auto_approve_arg
    end

    def auto_approve_arg
      @options[:yes] || @options[:auto] ? ["-auto-approve"] : []
    end
  end
end
