require "tempfile"

module Terraspace::Terraform::Args
  class Default
    def initialize(mod, name, options={})
      @mod, @name, @options = mod, name, options
      @quiet = @options[:quiet].nil? ? true : @options[:quiet]
    end

    def args
      # https://terraspace.cloud/docs/ci-automation/
      ENV['TF_IN_AUTOMATION'] = '1' if @options[:auto]

      if %w[apply destroy init output plan show].include?(@name)
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

      args << input_option

      # must be at the end
      plan = @options[:plan]
      if plan
        if plan.starts_with?('/')
          src  = plan
          dest = src
        else
          src = "#{Dir.pwd}/#{plan}"
          dest = "#{@mod.cache_dir}/#{File.basename(src)}"
        end
        FileUtils.cp(src, dest) unless same_file?(src, dest)
        args << " #{dest}"
      end
      args
    end

    def input_option
      option = if @options[:auto]
                 "false"
               else
                 @options[:input] ? @options[:input] : "false"
               end
      " -input=#{option}"
    end

    def init_args
      args = "-get"
      args << input_option
      args << " -reconfigure" if @options[:reconfigure]

      # must be at the end
      if @quiet
        log_path = self.class.terraform_init_log(@mod.name)
        FileUtils.mkdir_p(File.dirname(log_path))
        args << " >> #{log_path}"
      end
      [args]
    end

    def output_args
      args = []
      args << "-json" if @options[:format] == "json"
      args << "> #{expanded_out}" if @options[:out]
      args
    end

    def plan_args
      args = []
      args << input_option
      args << "-destroy" if @options[:destroy]
      args << "-out #{expanded_out}" if @options[:out]
      args
    end

    def show_args
      args = []
      args << " -json" if @options[:json]
      args << " #{@options[:plan]}" if @options[:plan] # terraform show /path/to/plan
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

    class << self
      extend Memoist

      # Use different tmp log file in case uses run terraspace up in 2 terminals at the same time
      #
      # Log for init is in /tmp because using shell >> redirection
      # It requires full path since we're running terraform within the .terraspace-cache folder
      # This keeps the printed command shorter:
      #
      #     => terraform init -get >> /tmp/terraspace/log/init/demo.log
      #
      def terraform_init_log(mod_name)
        "#{Terraspace.tmp_root}/log/init/#{mod_name}.log"
      end
      memoize :terraform_init_log
    end

  private
    def same_file?(src, dest)
      src == dest
    end
  end
end
