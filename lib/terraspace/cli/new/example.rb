class Terraspace::CLI::New
  class Example < Thor::Group
    include Thor::Actions

    # only stack name is configurable
    argument :name, default: "demo"

    def self.options
      # default is nil for autodetection
      [
        [:force, aliases: %w[f], type: :boolean, desc: "Force overwrite"],
        [:lang, default: "hcl", desc: "Language to use: HCL/ERB or Ruby DSL"],
        [:plugin, aliases: %w[p], default: nil, type: :string],
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
      args += ["--lang", @options[:lang]] if @options[:lang]
      args
    end
  end
end
