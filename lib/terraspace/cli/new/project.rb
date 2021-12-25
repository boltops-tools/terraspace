class Terraspace::CLI::New
  class Project < Sequence
    def self.project_options
      [
        [:bundle, type: :boolean, default: true, desc: "Runs bundle install on the project"],
        [:config, type: :boolean, default: true, desc: "Whether or not to generate config files."],
        [:force, aliases: %w[y], type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files."],
        [:quiet, type: :boolean, desc: "Quiet output."],
        [:test_structure, type: :boolean, desc: "Create project bootstrap test structure."],
      ]
    end

    base_options.each { |args| class_option(*args) }
    project_options.each { |args| class_option(*args) }

  private
    def log(msg)
      logger.info(msg) unless @options[:quiet]
    end

  public
    def creating_messaging
      log "=> Creating new project called #{name}"
    end

    def create_base
      plugin_template_source("base", "project")
      directory ".", "#{name}"
    end

    # Will generate config folder from
    #
    #     1. terraspace code lang templates or
    #     2. example lang templates from provider gems
    #
    def create_project
      plugin_template_source(@options[:lang], "project") # IE: plugin_template_source("hcl", "project")

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

    def create_test
      return unless @options[:test_structure]
      Test::Bootstrap.start(["--dir", name])
    end

    def bundle_install
      return if @options[:bundle] == false
      log "=> Installing dependencies with: bundle install"
      Bundler.with_unbundled_env do
        bundle = "BUNDLE_IGNORE_CONFIG=1 bundle install"
        bundle << " > /dev/null 2>&1" if @options[:quiet]
        system(bundle, chdir: name)
      end
    end

    def welcome_message_examples
      return unless options[:examples]
      log <<~EOL
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
      log <<~EOL
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
