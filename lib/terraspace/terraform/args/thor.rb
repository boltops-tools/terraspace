require "tempfile"

module Terraspace::Terraform::Args
  class Thor
    def initialize(mod, name, options={})
      @mod, @name, @options = mod, name.underscore, options
      @quiet = @options[:quiet].nil? ? true : @options[:quiet]
    end

    def args
      # https://terraspace.cloud/docs/ci-automation/
      ENV['TF_IN_AUTOMATION'] = '1' if @options[:auto]

      args = []

      if straight_delegate_args?
        args += @options[:rest]
        args.flatten!
      end

      args_meth = "#{@name}_args".gsub(' ', '_') # IE: apply_args, init_args
      if respond_to?(args_meth)
        args += send(args_meth)
      end

      args
    end

    # delegate args straight through for special commands, currently state seems to be the only case
    def straight_delegate_args?
      @name.include?("state") # IE: "state list", "state pull", "state show"
    end

    def force_unlock_args
      [" -force #{@options[:lock_id]}"]
    end

    def apply_args
      args = auto_approve_arg
      var_files = @options[:var_files]
      if var_files
        var_files.each do |file|
          copy_to_cache(file)
        end
        args << var_files.map { |f| "-var-file #{f}" }.join(' ')
      end

      args << input_option

      # must be at the end
      plan = @options[:plan]
      if plan
        copy_to_cache(plan)
        args << " #{plan}"
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
      args << "> #{expanded_out}" if @options[:out]
      args
    end

    def plan_args
      args = []
      args << input_option
      args << "-destroy" if @options[:destroy]
      args << "-out #{expanded_out}" if @options[:out]
      # Note: based on the @options[:out] will run an internal hook to copy plan
      # file back up to the root project folder for use. Think this is convenient and expected behavior.
      args
    end

    def show_args
      args = []
      plan = @options[:plan]
      if plan
        copy_to_cache(@options[:plan])
        args << " #{@options[:plan]}" # terraform show /path/to/plan
      end
      args
    end

    def expanded_out
      @options[:out]
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

    def copy_to_cache(file)
      return if file =~ %r{^/} # not need to copy absolute path
      name = file.sub("#{Terraspace.root}/",'')
      src = name
      dest = "#{@mod.cache_dir}/#{name}"
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp(src, dest) unless same_file?(src, dest)
    end
  end
end
