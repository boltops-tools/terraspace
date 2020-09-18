module Terraspace::Compiler
  module DirsConcern
    extend ActiveSupport::Concern
    extend Memoist

    def cache_dirs
      cache_dirs = []
      with_each_mod("stacks") do |mod|
        cache_dirs << mod.cache_dir
      end
      cache_dirs
    end

    def with_each_mod(type_dir)
      mod_names(type_dir).each do |mod_name|
        consider_stacks = type_dir == "stacks"
        mod = Terraspace::Mod.new(mod_name, @options.merge(consider_stacks: consider_stacks))
        yield(mod)
      end
    end

    def mod_names(type_dir)
      names, built = [], []
      local_paths(type_dir).each do |path|
        next unless File.directory?(path)
        mod_name = File.basename(path)
        next if built.include?(mod_name) # ensures modules in app folder take higher precedence than vendor folder
        names << mod_name
      end
      names
    end
    memoize :mod_names

    def local_paths(type_dir)
      dirs("app/#{type_dir}/*") + dirs("vendor/#{type_dir}/*")
    end

    def dirs(path)
      Dir.glob("#{Terraspace.root}/#{path}")
    end

    def stack_names
      mod_names("stacks") - Terraspace.config.all.ignore_stacks
    end
    memoize :stack_names
  end
end
