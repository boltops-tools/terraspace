module Terraspace::Terraform::Ihooks::After
  class Plan < Terraspace::Terraform::Ihooks::Base
    def run
      return if !out_option || @options[:copy_to_root] == false
      copy_to_root(out_option)
    end

    def copy_to_root(file)
      return if file =~ %r{^/} # not need to copy absolute path
      name = file.sub("#{Terraspace.root}/",'')
      src = "#{@mod.cache_dir}/#{name}"
      dest = name
      FileUtils.mkdir_p(File.dirname(dest))
      FileUtils.cp(src, dest)
    end
  end
end
