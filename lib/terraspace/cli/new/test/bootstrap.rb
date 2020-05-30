module Terraspace::CLI::New::Test
  class Bootstrap < Base
    def create
      puts "=> Creating test boostrap structure"
      test_template_source("bootstrap")
      directory ".", "."
    end
  end
end
