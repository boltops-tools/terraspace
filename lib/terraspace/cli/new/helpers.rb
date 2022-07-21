class Terraspace::CLI::New
  module Helpers
    include Helpers::PluginGem

  private
    def build_gemfile(*list)
      lines = []
      list.compact.each do |name|
        lines << gem_line(name)
      end
      lines.join("\n")
    end

    def gem_line(name)
      if name == "terraspace"
        major_version = Terraspace::VERSION.split('.').first
        %Q|gem "#{name}", '~> #{major_version}'|
      else
        %Q|gem "#{name}"|
      end
    end
  end
end
