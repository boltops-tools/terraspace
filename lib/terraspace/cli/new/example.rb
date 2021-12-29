class Terraspace::CLI::New
  class Example < Thor::Group
    include Thor::Actions

    # only stack name is configurable
    argument :name, default: "demo"

    def self.options
      # default is nil for autodetection
      [
        [:plugin, aliases: %w[p], default: nil, type: :string],
        [:force, aliases: %w[f], type: :boolean, desc: "Force overwrite"],
      ]
    end
    options.each { |args| class_option(*args) }

    def create
      Module.start(["example", "--examples"] + cli_args)
      Stack.start([name, "--examples"] + cli_args)
    end

  private
    def cli_args
      plugin = @options[:plugin] || Terraspace::Autodetect.new.plugin
      args = if plugin
        ['--plugin', plugin]
      else
        ['--plugin', 'none'] # override default of aws
      end
      args << "--force" if @options[:force]
      args
    end
  end
end
