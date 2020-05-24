class Terraspace::CLI::New
  class Project < Sequence
    def self.project_options
      [
        [:bucket, desc: "Bucket to store terraform.tfstate file"],
      ]
    end

    base_options.each { |args| class_option(*args) }
    project_options.each { |args| class_option(*args) }

    def creating_messaging
      puts "=> Creating new project called #{name}."
    end

    # Note: Tried multiple sources but that doesnt seem to work, so using this approach instead
    def create_base
      Base.start([name])
    end

    def setup_source
      set_source("project")
    end

    def create_project
      directory ".", "#{name}"
    end

    def empty_dirs
      return if @options[:examples]
      empty_directory("#{name}/app/modules")
      empty_directory("#{name}/app/stacks")
    end

    def create_starter_module
      return unless @options[:examples]
      Module.start(component_args("example", name))
    end

    def create_starter_stack
      return unless @options[:examples]
      Stack.start(component_args("demo", name))
    end

    def welcome_message_examples
      return unless options[:examples]
      puts <<~EOL
        #{"="*64}
        Congrats! You have successfully created a terraspace project.
        Check out the created files. Adjust to the examples and then deploy with:

            cd #{name}
            terraspace up demo -y   # to deploy
            terraspace down demo -y # to destroy

        More info: https://terraspace.cloud/
      EOL
    end

    def welcome_message_no_examples
      return if options[:examples]
      puts <<~EOL
        #{"="*64}
        Congrats! You have successfully created a terraspace project.
        Check out the created files.

            cd #{name}

        You can create modules and stacks with their generators:

            terraspace new module demo
            terraspace new stack demo

        When you are ready, you can deploy with:

            terraspace up demo -y   # to deploy

        And destroy with:

            terraspace down demo -y # to destroy

        More info: https://terraspace.cloud/
      EOL
    end
  end
end
