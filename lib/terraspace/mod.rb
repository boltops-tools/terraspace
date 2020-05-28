module Terraspace
  # Example properties:
  #
  #     name: vpc
  #     root: app/modules/vpc, app/stacks/vpc, vendor/modules/vpc or vendor/stacks/vpc
  #     type: module or stack
  #
  class Mod
    extend Memoist

    attr_reader :consider_stacks, :name
    def initialize(name, consider_stacks: true)
      @name = name
      @consider_stacks = consider_stacks
    end

    attr_accessor :root_module
    def root_module?
      @root_module
    end

    def check_exist!
      return if root

      pretty_paths = paths.map { |p| Terraspace::Util.pretty_path(p) }
      puts "ERROR: Unable to find #{@name.color(:green)} module. Searched paths: #{pretty_paths}"
      ENV['TS_TEST'] ? raise : exit(1)
    end

    def to_info
      {
        build_dir: build_dir,
        cache_build_dir: cache_build_dir,
        name: name,
        root: root,
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
    def build_dir
      "#{type_dir}/#{name}"
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
