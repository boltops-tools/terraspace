class Module
  # Include all modules within the relative folder. IE: for dsl/syntax/mod/*
  #
  #    include Common
  #    include Provider
  #    # etc
  #
  # Caller lines are different for OSes:
  #
  #   windows: "C:/Ruby31-x64/lib/ruby/gems/3.1.0/gems/terraspace-1.1.1/lib/terraspace/builder.rb:34:in `build'"
  #   linux: "/home/ec2-user/.rvm/gems/ruby-3.0.3/gems/terraspace-1.1.1//lib/terraspace/compiler/dsl/syntax/mod.rb:4:in `<module:Mod>'"
  #
  def include_dir(dir)
    caller_line = caller[0]
    parts = caller_line.split(':')
    calling_file = caller_line.match(/^[a-zA-Z]:/) ? parts[1] : parts[0]
    parent_dir = File.dirname(calling_file)

    full_dir = "#{parent_dir}/#{dir}"
    Dir.glob("#{full_dir}/**/*").each do |path|
      regexp = Regexp.new(".*/lib/")
      klass = path.sub(regexp, '').sub('.rb','').camelize
      include klass.constantize
    end
  end

  def include_project_level_helpers
    full_dir = "#{Terraspace.root}/config/helpers"
    Dir.glob("#{full_dir}/**/*").each do |path|
      regexp = Regexp.new(".*/config/helpers/")
      klass = path.sub(regexp, '').sub('.rb','').camelize
      klass = "Terraspace::Project::#{klass}"
      include klass.constantize
    end
  end

  def include_plugin_helpers
    Terraspace::Plugin.helper_classes.each do |klass|
      include klass # IE: TerraspacePluginAws::Interfaces::Helper
    end
  end
end
