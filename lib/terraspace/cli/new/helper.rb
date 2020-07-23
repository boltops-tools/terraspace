class Terraspace::CLI::New
  module Helper
    include Helper::PluginGem

  private
    def build_gemfile(*list)
      lines = []
      list.each do |name|
        line =  %Q|gem "#{name}"|
        lines << line
      end
      lines.join("\n")
    end
  end
end
