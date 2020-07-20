class Terraspace::CLI::New
  module Helpers
    include Helpers::PluginGem

  private
    def build_gemfile(*list)
      lines = []
      list.each do |name|
        lines << gem_line(name)
      end
      lines.join("\n")
    end

    def gem_line(name)
      if name == "terraspace"
        %Q|gem "#{name}", '~> #{Terraspace::VERSION}'|
      else
        %Q|gem "#{name}"|
      end
    end
  end
end
