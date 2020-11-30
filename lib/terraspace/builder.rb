module Terraspace
  class Builder < Terraspace::CLI::Base
    include Compiler::CommandsConcern
    include Compiler::DirsConcern
    include Hooks::Concern

    attr_reader :graph

    def run
      return if @options[:build] == false
      Terraspace::CLI::CheckSetup.check!
      @mod.root_module = true
      clean
      build_dir = Util.pretty_path(@mod.cache_dir)
      placeholder_stack_message
      logger.info "Building #{build_dir}" unless @options[:quiet] # from terraspace all

      batches = nil
      FileUtils.mkdir_p(@mod.cache_dir) # so terraspace before build hooks work
      run_hooks("terraspace.rb", "build") do
        build_unresolved
        auto_create_backend
        batches = build_batches
        build_all
        logger.info "Built in #{build_dir}" unless @options[:quiet] # from terraspace all
      end
      batches
    end

    # Builds dependency graph and returns the batches to run
    def build_batches
      dependencies = Terraspace::Dependency::Registry.data # populated after build_unresolved
      @graph = Terraspace::Dependency::Graph.new(stack_names, dependencies, @options)
      @graph.build
    end

    def build_all
      # At this point dependencies have been resolved.
      Terraspace::Terraform::RemoteState::Fetcher.flush!
      @resolved = true
      build_unresolved
    end

    def build_unresolved
      build_dir("modules")
      build_dir("stacks")
      build_root_module
    end

    def build_root_module
      @mod.resolved = @resolved
      Compiler::Builder.new(@mod).build
    end

    def build_dir(type_dir)
      with_each_mod(type_dir) do |mod|
        mod.resolved = @resolved
        is_root_module = mod.cache_dir == @mod.cache_dir
        next if is_root_module # handled by build_root_module
        Compiler::Builder.new(mod).build
      end
    end

    # Auto create after build_unresolved since will need to run state pull for dependencies
    def auto_create_backend
      return if Terraspace.config.auto_create_backend == false
      return unless requires_backend?
      Terraspace::Compiler::Backend.new(@mod).create
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
