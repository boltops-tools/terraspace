class Terraspace::CLI::New
  class Test < Sequence
    argument :name

    def self.test_options
      [
        [:bootstrap, type: :boolean, default: false, desc: "Also create bootstrap structure"],
      ]
    end

    test_options.each { |args| class_option(*args) }

    def bootstrap_structure
      return unless @options[:bootstrap]

      puts "=> Creating test boostrap structure"
      test_template_source("bootstrap")
      directory ".", "."
    end

    def create_test
      puts "=> Creating test: #{name}"
      test_template_source("project")
      directory ".", "."
    end
  end
end
