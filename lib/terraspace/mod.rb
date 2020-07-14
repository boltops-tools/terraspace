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
    def initialize(name, options={})
      @name, @options = name, options
      @consider_stacks = options[:consider_stacks].nil? ? true : options[:consider_stacks]
      @instance = options[:instance]
    end

    attr_accessor :root_module
    def root_module?
      @root_module
    end

    def check_exist!
      return if root

      pretty_paths = paths.map { |p| Terraspace::Util.pretty_path(p) }
      logger.error "ERROR: Unable to find #{@name.color(:green)} module. Searched paths: #{pretty_paths}"
      ENV['TS_TEST'] ? raise : exit(1)
    end

    def to_info
      {
        build_dir: build_dir,
        cache_build_dir: Terraspace::Util.pretty_path(cache_build_dir),
        name: name,
        root: Terraspace::Util.pretty_path(root),
        type: type,
        type_dir: type_dir,
      }
    end

    def root
      paths.find { |p| File.exist?(p) }
    end
    memoize :root

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
      if !disable_instance && !@instance.nil?
        # add _ in front so instance doesnt collide with other default stacks
        instance_name = [name, @instance].compact.join('.')
      else
        instance_name = name
      end
      [type_dir, instance_name].compact.join('/')
    end

    # Full path with build_dir
    def cache_build_dir
      "#{Terraspace.cache_root}/#{Terraspace.env}/#{build_dir}"
    end

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
