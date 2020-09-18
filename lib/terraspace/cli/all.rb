class Terraspace::CLI
  class All < Terraspace::Command
    class_option :yes, aliases: :y, type: :boolean, desc: "auto approve all batch commands"
    class_option :exit_on_fail, type: :boolean, desc: "whether or not to exit when one of the batch commands fails"

    desc "down", "destroy all"
    long_desc Help.text("all/down")
    option :destroy_workspace, type: :boolean, desc: "Also destroy the Cloud workspace. Only applies when using Terraform Cloud remote backend."
    def down(*stacks)
      Terraspace::All::Runner.new("down", @options.merge(stacks: stacks)).run
    end

    desc "graph", "graph all"
    long_desc Help.text("all/graph")
    option :format, default: "png", desc: "format: text or diagram"
    option :full,type: :boolean, desc: "draw the full graph with highlighted nodes or draw the subgraph. text format defaults to false, graph format defaults to true"
    def graph(*stacks)
      Terraspace::All::Grapher.new(@options.merge(stacks: stacks)).run
    end

    desc "refresh", "refresh all"
    long_desc Help.text("all/refresh")
    def refresh(*stacks)
      Terraspace::All::Runner.new("refresh", @options.merge(stacks: stacks)).run
    end

    desc "output", "output all"
    long_desc Help.text("all/output")
    def output(*stacks)
      Terraspace::All::Runner.new("output", @options.merge(stacks: stacks)).run
    end

    desc "plan", "plan all"
    long_desc Help.text("all/plan")
    def plan(*stacks)
      Terraspace::All::Runner.new("plan", @options.merge(stacks: stacks)).run
    end

    desc "providers", "providers all"
    long_desc Help.text("all/providers")
    def providers(*stacks)
      Terraspace::All::Runner.new("providers", @options.merge(stacks: stacks)).run
    end

    desc "show", "show all"
    long_desc Help.text("all/show")
    def show(*stacks)
      Terraspace::All::Runner.new("show", @options.merge(stacks: stacks)).run
    end

    desc "up", "deploy all"
    long_desc Help.text("all/up")
    def up(*stacks)
      Terraspace::All::Runner.new("up", @options.merge(stacks: stacks)).run
    end

    desc "validate", "validate all"
    long_desc Help.text("all/validate")
    def validate(*stacks)
      Terraspace::All::Runner.new("validate", @options.merge(stacks: stacks)).run
    end
  end
end
