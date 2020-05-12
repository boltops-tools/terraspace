module Terraspace::Compiler
  class Writer
    def initialize(mod, options={})
      @mod, @options = mod, options
      @src_path = options[:src_path]
      @dest_name = options[:dest_name] # override generated name
    end

    def dest_path
      name = @dest_name || File.basename(@src_path).sub('.rb','.tf.json')
      "#{dest_dir}/#{name}"
    end

    def dest_dir
      if @mod.is_a?(Terraspace::Mod::Remote)
        File.dirname(@src_path) # for Mod::Remote src is dest
      else
        @mod.cache_build_dir
      end
    end

    def write(content)
      FileUtils.mkdir_p(File.dirname(dest_path))
      IO.write(dest_path, content)
      puts "Created #{Terraspace::Util.pretty_path(dest_path)}" if ENV['TS_LOUD']
    end
  end
end
