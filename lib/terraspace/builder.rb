module Terraspace
  class Builder < Terraspace::CLI::Base
    include Compiler::CommandsConcern
    include Compiler::DirsConcern
    include Hooks::Concern

    def run
      return if @options[:build] == false
      Terraspace::CLI::Setup::Check.check!
      check_allow!
      @mod.root_module = true
      clean
      build
    end

    def build(modules: true, stack: true)
      build_dir = Util.pretty_path(@mod.cache_dir)
      placeholder_stack_message
      logger.info "Building #{build_dir}" unless @options[:quiet] # from terraspace all
      FileUtils.mkdir_p(@mod.cache_dir) # so terraspace before build hooks work
      run_hooks("terraspace.rb", "build") do
        build_dir("modules") if modules
        build_root_module if stack
        logger.info "Built in #{build_dir}" unless @options[:quiet] # from terraspace all
      end
    end

    def check_allow!
      Allow.new(@mod).check!
    end

    def build_root_module
      @mod.resolved = true
      Compiler::Perform.new(@mod).compile
    end

    def build_dir(type_dir)
      with_each_mod(type_dir) do |mod|
        mod.resolved = true
        is_root_module = mod.cache_dir == @mod.cache_dir
        next if is_root_module # handled by build_root_module
        Compiler::Perform.new(mod).compile
      end
    end

    def clean
      Compiler::Cleaner.new(@mod, @options).clean if clean?
    end

    def clean?
      if @options[:clean].nil?
        clean_cache = Terraspace.config.build.clean_cache
        clean_cache.nil? ? true : clean_cache
      else
        @options[:clean]
      end
    end

    def placeholder_stack_message
      return if @options[:quiet]
      return unless @options[:mod] == "placeholder"
      logger.info "Building one stack to build all stacks"
    end
  end
end
