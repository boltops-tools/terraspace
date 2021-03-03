module Terraspace::Terraform::Ihooks::Before
  class Plan < Terraspace::Terraform::Ihooks::Base
    def run
      out = @options[:out]
      return unless out
      return if out =~ %r{^/} # not need to create parent dir for copy with absolute path

      out = @options[:out]
      name = out.sub("#{Terraspace.root}/",'')
      dest = "#{@mod.cache_dir}/#{name}"
      FileUtils.mkdir_p(File.dirname(dest))
    end
  end
end
