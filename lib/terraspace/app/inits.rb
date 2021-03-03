class Terraspace::App
  class Inits
    class << self
      include DslEvaluator

      def run_all
        Dir.glob("#{Terraspace.root}/config/inits/*.rb").each do |path|
          evaluate_file(path)
        end
      end
    end
  end
end
