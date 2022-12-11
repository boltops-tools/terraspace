module Terraspace::Compiler
  class Writer
    include Basename
    include Terraspace::Util

    def initialize(mod, options={})
      @mod, @options = mod, options
      @src_path = options[:src_path]
      @dest_name = options[:dest_name] # override generated name
    end

    def dest_path
      name = get_name
      name = basename(name)
      "#{dest_dir}/#{name}"
    end

    def get_name
      return @dest_name if @dest_name
      return @src_path if Terraspace.pass_file?(@src_path)
      @src_path.sub('.rb','.tf.json')
    end

    def dest_dir
      if @mod.is_a?(Terraspace::Mod::Remote)
        File.dirname(@src_path) # for Mod::Remote src is dest
      else
        @mod.cache_dir
      end
    end

    def write(content)
      FileUtils.mkdir_p(File.dirname(dest_path))
      if content.respond_to?(:path) # IO filehandle
        FileUtils.cp(content.path, dest_path) # preserves permission
      else # just content
        IO.write(dest_path, content, mode: "wb") unless content.nil?
      end
      logger.debug "Created #{Terraspace::Util.pretty_path(dest_path)}"
    end
  end
end
