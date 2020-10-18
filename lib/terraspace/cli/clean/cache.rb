class Terraspace::CLI::Clean
  class Cache < Base
    def run
      Terraspace.check_project!
      paths = [Terraspace.cache_root, Terraspace.tmp_root]
      are_you_sure?(paths)
      paths.each do |path|
        FileUtils.rm_rf(path)
        puts "Removed #{pretty(path)}"
      end
    end

    def are_you_sure?(paths)
      pretty_paths = paths.map { |p| "    #{pretty(p)}" }.join("\n")
      message = <<~EOL.chomp
        Will remove these folders and all their files:

        #{pretty_paths}

        Are you sure?
      EOL
      sure?(message) # from Util::Sure
    end
  end
end
