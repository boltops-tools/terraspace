class Terraspace::Completer::Script
  def self.generate
    bash_script = File.expand_path("script.sh", File.dirname(__FILE__))
    logger.info "source #{bash_script}"
  end
end
