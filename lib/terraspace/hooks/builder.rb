module Terraspace::Hooks
  class Builder
    extend Memoist
    include Dsl
    include DslEvaluator
    include Terraspace::Util

    # IE: dsl_file: config/hooks/terraform.rb
    attr_accessor :name
    def initialize(mod, file, name)
      @mod, @file, @name = mod, file, name
      @hooks = {before: {}, after: {}}
    end

    def build
      evaluate_file("#{Terraspace.root}/config/hooks/#{@file}")
      evaluate_file("#{@mod.root}/config/hooks/#{@file}")
      @hooks.deep_stringify_keys!
    end
    memoize :build

    def run_hooks
      build
      run_each_hook("before")
      out = yield if block_given?
      run_each_hook("after")
      out
    end

    def run_each_hook(type)
      hooks = @hooks.dig(type, @name) || []
      hooks.each do |hook|
        run_hook(type, hook)
      end
    end

    def run_hook(type, hook)
      return unless run?(hook)

      command = File.basename(@file).sub('.rb','') # IE: terraform or terraspace
      id = "#{command} #{type} #{@name}"
      label = " label: #{hook["label"]}" if hook["label"]
      logger.info  "Hook: Running #{id} hook.#{label}".color(:cyan)
      Runner.new(@mod, hook).run
    end

    def run?(hook)
      !!hook["execute"]
    end
  end
end
