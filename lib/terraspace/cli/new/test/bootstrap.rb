module Terraspace::CLI::New::Test
  class Bootstrap < Base
    def self.options
      [
        [:dir, default: ".", desc: "directory to write to"],
      ]
    end

    options.each { |args| class_option(*args) }

    def create
      puts "=> Creating test bootstrap structure"
      test_template_source("bootstrap")
      directory ".", options[:dir]
    end
  end
end
