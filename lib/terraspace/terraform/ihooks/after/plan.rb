module Terraspace::Terraform::Ihooks::After
  class Plan < Terraspace::Terraform::Ihooks::Base
    def run
      return if !@options[:out] || @options[:copy_to_root] == false
      copy_to_root(@options[:out])
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
