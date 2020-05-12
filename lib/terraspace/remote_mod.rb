module Terraspace
  class RemoteMod < Mod
    def initialize(meta, parent)
      # meta: from .terraform/modules/modules.json. Example structure: spec/fixtures/initialized/modules.json
      # parent: parent module or stack. IE: terraspace build MOD
      @meta, @parent  = meta, parent
      @name = @meta['Key']
    end

    def root
      "#{@parent.cache_build_dir}/#{@meta['Dir']}"
    end

    def type
      "module"
    end
  end
end
