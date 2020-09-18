require 'cli-format'

class Terraspace::CLI::Cloud
  class Runs < Terraspace::Command
    Help = Terraspace::CLI::Help
    Runs = Terraspace::Terraform::Cloud::Runs

    desc "list STACK", "List runs."
    long_desc Help.text("cloud:runs:list")
    option :format, desc: "Output formats: #{CliFormat.formats.join(', ')}"
    option :status, default: %w[pending planned], type: :array, desc: "Filter by statuses: pending, planned, all"
    def list(mod)
      Runs.new(options.merge(mod: mod)).list
    end

    desc "prune STACK", "Prune runs that are possible to cancel or discard."
    long_desc Help.text("cloud:runs:prune")
    option :noop, type: :boolean, desc: "Shows what would be cancelled/discarded."
    option :yes, aliases: :y, type: :boolean, desc: "bypass are you sure prompt"
    def prune(mod)
      Runs.new(options.merge(mod: mod)).prune
    end
  end
end
