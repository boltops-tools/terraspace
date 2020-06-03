module Terraspace::Compiler
  module Basename
    def basename(path)
      # double escape of \\w is tricky
      regexp = Regexp.new(".*(app|vendor)\/\\w+\/#{@mod.name}\/")
      path.sub(%r{.*config/terraform/}, '')
          .sub(regexp,'')
    end
  end
end
