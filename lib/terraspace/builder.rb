module Terraspace
  class Builder < Terraspace::CLI::Base
    include Compiler::CommandsConcern
    include Compiler::DirsConcern
    include Hooks::Concern

    # @include_stacks can be 3 values: root_with_children, none, root_only
    #
    # terraspace all:
    #
    #     none: dont build any stacks at all. used by `terraspace all up`
    #     root_only: only build root stack. used by `terraspace all up`
    #     root_with_children: build all children stacks as well as the root stack. normal `terraspace all down`
    #
    # terraspace up:
    #
    #     root_with_children: build all children stacks as well as the root stack. normal `terraspace up`
    #
    def initialize(options={})
      super
      @include_stacks = @options[:include_stacks] || :root_with_children
    end

    def run
      return if @options[:build] == false
      Terraspace::Check.check!
      check_allow!
      @mod.root_module = true
      clean
      resolve_dependencies if @include_stacks == :root_with_children
      build
    end

    def resolve_dependencies
      resolver = Terraspace::Dependency::Resolver.new(@options.merge(quiet: true))
      resolver.resolve # returns batches
    end

    def build(modules: true)
      build_dir = Util.pretty_path(@mod.cache_dir)
      placeholder_stack_message
      logger.info "Building #{build_dir}" unless @options[:quiet] # from terraspace all
      FileUtils.mkdir_p(@mod.cache_dir) # so terraspace before build hooks work
      run_hooks("terraspace.rb", "build") do
        build_dir("modules") if modules
        build_stacks
        logger.debug "Built in #{build_dir}"
      end
    end

    def check_allow!
      Allow.new(@mod).check!
    end

    def build_stacks
      return if @include_stacks == :none
      build_children_stacks if @include_stacks == :root_with_children
      Compiler::Perform.new(@mod).compile # @include_stacks :root or :root_with_children
    end

    # Build stacks that are part of the dependency graph. Because .terraspace-cache folders
    # need to exist so `terraform state pull` works to get the state info.
    def build_children_stacks
      children = Children.new(@mod, @options)
      children.build
    end

    def build_dir(type_dir)
      with_each_mod(type_dir) do |mod|
        is_root_module = mod.cache_dir == @mod.cache_dir
        next if is_root_module # handled by build_stacks
        Compiler::Perform.new(mod, type_dir: type_dir).compile
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
