class Terraspace::CLI::New
  module Helpers
    include Helpers::PluginGem

  private
    def terraspace_minor_version
      major, minor, _ = Terraspace::VERSION.split('.')
      [major, minor, '0'].join('.')
    end
  end
end
