module Terraspace::Terraform::Args
  class Builder
    extend Memoist
    include Dsl
    include DslEvaluator

    attr_accessor :name
    def initialize(mod, name)
      @mod, @name = mod, name
      @file = "#{Terraspace.root}/config/cli/args.rb"
      @commands = {}
    end

    def build
      return @commands unless File.exist?(@file)
      evaluate_file(@file)
      @commands.deep_stringify_keys!
    end
    memoize :build

    def args
      build
      args = dig("arguments")
      args.compact.flatten
    end

    def var_files
      var_files = dig("var_files")
      var_files.select! { |f| var_file_exist?(f) }
      var_files.map { |f| "-var-file=#{f}" }
    end

    def env_vars
      dig("env", {})
    end

    def var_file_exist?(var_file)
      File.exist?("#{@mod.cache_build_dir}/#{var_file}")
    end

    def dig(prop, default=[])
      @commands.dig(@name, prop) || default
    end
  end
end
