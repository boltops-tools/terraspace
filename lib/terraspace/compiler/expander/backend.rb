# Simpler than Terraspace::Terraform::Runner::Backend::Parser because
# Terraspace::Compiler::Expander autodetect backend super early on.
# It's so early that don't want helper methods like <%= expansion(...) %> to be called.
# Calling the expansion helper itself results in Terraspace autodetecting a concrete
# Terraspace Plugin Expander, which creates an infinite loop.
# This simple detection class avoids calling ERB and avoids the infinite loop.
class Terraspace::Compiler::Expander
  class Backend
    extend Memoist

    def initialize(mod)
      @mod = mod
    end

    COMMENT = /^\s+#/
    # Works for both backend.rb DSL and backend.tf ERB
    def detect
      return nil unless src_path # no backend file. returning nil means a local backend
      lines = IO.readlines(src_path)
      backend_line = lines.find { |l| l.include?("backend") && l !~ COMMENT }
      md = backend_line.match(/['"](.*)['"]/)
      md[1] if md
    end

  private
    # Use original unrendered source as wont know the
    # @mod.cache_dir = ":CACHE_ROOT/:REGION/:ENV/:BUILD_DIR"
    # Until the concrete Terraspace Plugin Expander has been autodetected.
    # Follow same precedence rules as rest of Terraspace.
    def src_path
      exprs = [
        "app/stacks/#{@mod.build_dir}/backend.*",
        "app/modules/#{@mod.build_dir}/backend.*",
        "vendor/stacks/#{@mod.build_dir}/backend.*",
        "vendor/modules/#{@mod.build_dir}/backend.*",
        "config/terraform/backend.*",
      ]
      path = nil
      exprs.find { |expr| path = Dir.glob(expr).first }
      path
    end
    memoize :src_path
  end
end
