module Terraspace
  # Example properties:
  #
  #     name: vpc
  #     root: app/modules/vpc, app/stacks/vpc, vendor/modules/vpc or vendor/stacks/vpc
  #     type: module or stack
  #
  class Mod
    extend Memoist
    include Terraspace::Util

    attr_reader :name, :consider_stacks, :instance, :options
    attr_accessor :resolved # dependencies resolved
    def initialize(name, options={})
      @name, @options = placeholder(name), options
      @consider_stacks = options[:consider_stacks].nil? ? true : options[:consider_stacks]
      @instance = options[:instance]
    end

    def placeholder(name)
      if name == "placeholder"
        Terraspace::CLI::Build::Placeholder.new(@options).find_stack
      else
        name
      end
    end

    attr_accessor :root_module
    def root_module?
      @root_module
    end

    def check_exist!
      return if root

      pretty_paths = paths.map { |p| Terraspace::Util.pretty_path(p) }.join(", ")
      logger.error <<~EOL
        ERROR: Unable to find #{@name.color(:green)}. Searched paths:

            #{pretty_paths}

        To see available stacks, try running:

            terraspace list

      EOL
      ENV['TS_TEST'] ? raise : exit(1)
    end

    def to_info
      {
        build_dir: build_dir,
        cache_dir: Terraspace::Util.pretty_path(cache_dir),
        name: name,
        root: Terraspace::Util.pretty_path(root),
        type: type,
        type_dir: type_dir,
      }
    end

    def root
      root = paths.find { |p| File.exist?(p) }
      if root.nil?
        possible_fake_root
      else
        root
      end
    end
    memoize :root

    # If the app/stacks/NAME has been removed in source code but stack still exist in the cloud.
    # allow user to delete by materializing an empty stack with the backend.tf
    # Note this does not seem to work for Terraform Cloud as terraform init doesnt seem to download the plugins
    # required. SIt only works for s3, azurerm, and gcs backends. On TFC, you can delete the stack via the GUI though.
    #
    #   down - so user can delete stacks w/o needing to create an empty app/stacks/demo folder
    #   null - for the terraspace summary command when there are zero stacks.
    #          Also useful for terraspace tfc list_workspaces
    #
    def possible_fake_root
      if @options[:command] == "down"
        "#{Terraspace.root}/app/stacks/#{@name}" # fake stack root
      end
    end

    def exist?
      !!root
    end

    # Relative folder path without app or vendor. For example, the actual location can be found in a couple of places
    #
    #     app/modules/vpc
    #     app/stacks/vpc
    #     vendor/modules/vpc
    #     vendor/stacks/vpc
    #
    # The build folder does not include the app or vendor info.
    #
    #     modules/vpc
    #
    def build_dir(disable_instance: false)
      if !@instance.nil? && type_dir == "stacks" && !disable_instance
        # add _ in front so instance doesnt collide with other default stacks
        # never add for app/modules sources
        instance_name = [name, @instance].compact.join('.')
      else
        instance_name = name
      end
      [type_dir, instance_name].compact.join('/')
    end

    # Full path with build_dir
    def cache_dir
      pattern = Terraspace.config.build.cache_dir # IE: :CACHE_ROOT/:REGION/:ENV/:BUILD_DIR
      expander = Terraspace::Compiler::Expander.autodetect(self)
      expander.expansion(pattern)
    end
    memoize :cache_dir

    def type
      root.include?("/stacks/") ? "stack" : "module"
    end

    def type_dir
      type.pluralize
    end

  private
    def paths
      paths = []
      root = Terraspace.root
      paths << "#{root}/app/stacks/#{@name}" if @consider_stacks
      paths << "#{root}/app/modules/#{@name}"
      paths << "#{root}/vendor/stacks/#{@name}" if @consider_stacks
      paths << "#{root}/vendor/modules/#{@name}"
      paths
    end
  end
end
