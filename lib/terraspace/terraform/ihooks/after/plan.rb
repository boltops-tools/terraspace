module Terraspace::Terraform::Ihooks::After
  class Plan < Terraspace::Terraform::Ihooks::Base
    include Terraspace::CLI::Concerns::PlanPath

    def run
      return if !@mod.out_option || @options[:copy_to_root] == false
      @success = copy_to_root(@mod.out_option)
      cloud_create_plan
    end

    def copy_to_root(file)
      return if file =~ %r{^/} # not need to copy absolute path
      name = file.sub("#{Terraspace.root}/",'')
      src = "#{@mod.cache_dir}/#{name}"
      dest = name
      return false unless File.exist?(src) # plan wont exists if the plan errors
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp(src, dest)
      !!dest
    end

    def cloud_create_plan
      return unless Terraspace.cloud?

      unless @mod.out_option.include?(".cache2/")
        # copy absolute path directly
        src = @mod.out_option.starts_with?('/') ? @mod.out_option : "#{@mod.cache_dir}/#{@mod.out_option}"
        dest = "#{@mod.cache_dir}/#{plan_path}"
        FileUtils.mkdir_p(File.dirname(dest))
        FileUtils.cp(src, dest)
      end

      # for both:
      #   terraspace plan demo --destroy
      #   terraspace down demo
      kind = destroy? ? "destroy" : "apply"
      if Terraspace.command?("plan")
        Terraspace::Cloud::Plan.new(@options.merge(stack: @mod.name, kind: kind)).run
      end
      # create update if not plan and plan failed
      if !Terraspace.command?("plan") && !@success
        Terraspace::Cloud::Update.new(@options.merge(stack: @mod.name, kind: kind)).run
      end
    end
  end
end
