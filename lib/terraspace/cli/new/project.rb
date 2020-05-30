class Terraspace::CLI::New
  class Project < Sequence
    def self.project_options
      [
        [:bundle, type: :boolean, default: true, desc: "Runs bundle install on the project"],
        [:config, type: :boolean, default: true, desc: "Whether or not to generate config files."],
        [:force, type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files."],
      ]
    end

    base_options.each { |args| class_option(*args) }
    project_options.each { |args| class_option(*args) }

    def creating_messaging
      puts "=> Creating new project called #{name}."
    end

    # Note: Tried multiple sources but that doesnt seem to work, so using this approach instead
    def create_base
      args = [
        name,
        "--provider", @options[:provider],
        "--lang", @options[:lang],
      ]
      args << "--force" if @options[:force]
      Base.start(args)
    end

    def create_project
      set_source("base", "project")

      options = @options[:config] == false ? {exclude_pattern: "config" } : {}
      directory ".", "#{name}", options

      if @options[:config] == false
        empty_directory("#{name}/config")
      end
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

    def bundle_install
      return if @options[:bundle] == false
      puts "=> Installing dependencies with: bundle install"
      Bundler.with_unbundled_env do
        system("BUNDLE_IGNORE_CONFIG=1 bundle install", chdir: name)
      end
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

        You can create starter modules and stacks with their generators:

            terraspace new module example
            terraspace new stack demo

        Add your code to them, and deploy when you are ready:

            terraspace up demo -y   # to deploy

        Destroy with:

            terraspace down demo -y # to destroy

        More info: https://terraspace.cloud/
      EOL
    end
  end
end
