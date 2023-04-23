module Terraspace::Compiler::Strategy
  class AbstractBase
    def initialize(mod, src_path, options={})
      # options for type_dir
      @mod, @src_path, @options = mod, src_path, options
    end
  end
end
