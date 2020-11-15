class Module
  # Include all modules within the relative folder. IE: for dsl/syntax/mod/*
  #
  #    include Common
  #    include Provider
  #    # etc
  #
  def include_dir(dir)
    calling_file = caller[0].split(':').first # IE: /home/ec2-user/environment/terraspace/lib/terraspace/compiler/dsl/syntax/mod.rb
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
