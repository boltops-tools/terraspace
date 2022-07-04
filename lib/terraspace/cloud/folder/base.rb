class Terraspace::Cloud::Folder
  class Base < Terraspace::Cloud::Base
    def initialize(options={})
      super
      @type = options[:type]
    end

    # final zip dest
    def zip_path
      "#{artifacts_path}.zip"
    end

    def artifacts_path
      "#{@mod.cache_dir}/.terraspace-cache/.cache2/artifacts/#{@type}"
    end
  end
end
