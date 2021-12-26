class Terraspace::CLI
  module Help
    def text(namespaced_command)
      path = namespaced_command.to_s.gsub(':','/')
      path = File.expand_path("../help/#{path}.md", __FILE__)
      IO.read(path) if File.exist?(path)
    end
    extend self
  end
end
