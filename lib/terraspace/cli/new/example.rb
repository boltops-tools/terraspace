class Terraspace::CLI::New
  class Example < Thor::Group
    include Thor::Actions

    # only stack name is configurable
    argument :name, default: "demo"

    def create
      Module.start(["example"])
      Stack.start([name])
    end
  end
end
