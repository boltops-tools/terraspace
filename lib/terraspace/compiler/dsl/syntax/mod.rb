module Terraspace::Compiler::Dsl::Syntax
  module Mod
    include Terraspace::Util::Logging
    include_dir("mod")
    include_dir("helpers")
    include_plugin_helpers
    include_project_level_helpers
  end
end
