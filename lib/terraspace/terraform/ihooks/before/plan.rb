module Terraspace::Terraform::Ihooks::Before
  class Plan < Terraspace::Terraform::Ihooks::Base
    def run
      cani?

      return unless @mod.out_option
      return if @mod.out_option =~ %r{^/} # not need to create parent dir for copy with absolute path

      name = @mod.out_option.sub("#{Terraspace.root}/",'')
      dest = "#{@mod.cache_dir}/#{name}"
      FileUtils.mkdir_p(File.dirname(dest))
    end

    def cani?
      return unless Terraspace.cloud?
      kind = destroy? ? "destroy" : "apply"
      Terraspace::Cloud::Plan.new(@options.merge(stack: @mod.name, kind: kind)).cani?
    end
  end
end
