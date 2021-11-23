require "open3"

module Terraspace::Compiler::Strategy
  class Mod < AbstractBase
    def run
      klass = strategy_class(@src_path)
      strategy = klass.new(@mod, @src_path) # IE: Terraspace::Compiler::Strategy::Mod::Rb.new
      strategy.run
    end

    def strategy_class(path)
      ext = File.extname(path).sub('.','')
      return Mod::Pass if ext.empty? # infinite loop without this
      return Mod::Pass if Terraspace.pass_file?(path) or !text_file?(path)
      # Fallback to Mod::Tf for all other files. ERB useful for terraform.tfvars
      "Terraspace::Compiler::Strategy::Mod::#{ext.camelize}".constantize rescue Mod::Tf
    end

    # Thanks: https://stackoverflow.com/questions/2355866/ruby-how-to-determine-if-file-being-read-is-binary-or-text
    def text_file?(filename)
      file_type, status = Open3.capture2e("file", filename)
      status.success? && file_type.include?("text")
    end
  end
end
