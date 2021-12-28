class Terraspace::CLI::New
  class Example < Thor::Group
    include Thor::Actions

    # only stack name is configurable
    argument :name, default: "demo"

    def create
      Module.start(["example", "--examples"])
      Stack.start([name, "--examples"])
    end
  end
end
