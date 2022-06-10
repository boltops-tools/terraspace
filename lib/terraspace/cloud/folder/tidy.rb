class Terraspace::Cloud::Folder
  class Tidy < Base
    def cleanup
      removals.each do |removal|
        removal = removal.sub(%r{^/},'') # remove leading slash
        path = "#{artifacts_path}/#{removal}"
        rm_rf(path)
      end
    end

    def removals
      removals = always_removals
      removals += get_removals("#{artifacts_path}/.gitignore")
      removals = removals.reject do |p|
        tskeep.find do |keep|
          p.include?(keep)
        end
      end
      removals.uniq
    end

    def get_removals(file)
      path = file
      return [] unless File.exist?(path)

      removal = File.read(path).split("\n")
      removal.map {|i| i.strip}.reject {|i| i =~ /^#/ || i.empty?}
    end

    # We clean out ignored files pretty aggressively. So provide
    # a way for users to keep files from being cleaned out.
    def tskeep
      always_keep = %w[]
      path = "#{artifacts_path}/.tskeep"
      return always_keep unless File.exist?(path)

      keep = IO.readlines(path)
      keep = keep.map {|i| i.strip}.reject { |i| i =~ /^#/ || i.empty? }
      (always_keep + keep).uniq
    end

    def rm_rf(path)
      exists = File.exist?("#{path}/.gitkeep") || File.exist?("#{path}/.keep")
      return if exists

      FileUtils.rm_rf(path)
    end

    # These directories will be removed regardless of dir level
    def always_removals
      %w[.git spec tmp]
    end
  end
end
