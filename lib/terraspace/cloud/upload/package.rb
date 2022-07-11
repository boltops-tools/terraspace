require 'zip_folder'

class Terraspace::Cloud::Upload
  class Package < Base
    def build
      copy
      tidy
      zip # returns zip path
    end

    def copy
      FileUtils.rm_rf(artifacts_path)
      FileUtils.mkdir_p(File.dirname(artifacts_path))

      expr = "#{@mod.cache_dir}/.terraspace-cache/.cache2/#{@type}/*"
      Dir.glob(expr).each do |src|
        dest = "#{artifacts_path}/#{File.basename(src)}"
        FileUtils.mkdir_p(File.dirname(dest))
        FileUtils.cp(src, dest)
      end
    end

    def tidy
      Tidy.new(@options).cleanup
    end

    def zip
      FileUtils.rm_f(zip_path)
      ZipFolder.zip(artifacts_path, zip_path)
      zip_path
    end
  end
end
