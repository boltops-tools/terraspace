class Terraspace::CLI::New
  module Helper
    include Helper::PluginGem

  private
    def build_gemfile(*list)
      if ENV['TS_EDGE']
        base = ENV['TS_EDGE_ROOT'] || '#{ENV["HOME"]}/environment/terraspace-edge'
      end

      lines = []
      list.each do |name|
        line =  %Q|gem "#{name}"|
        line += %Q|, path: "#{base}/#{name}"| if base
        lines << line
      end
      lines.join("\n")
    end
  end
end
