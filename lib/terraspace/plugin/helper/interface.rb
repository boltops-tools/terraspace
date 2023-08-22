module Terraspace::Plugin::Helper
  module Interface
    extend ActiveSupport::Concern

    # Useful for plugin helpers. Can check this only run logic after dependency resolution.
    def resolved?
      !!@mod.resolved
    end

    class_methods do
      @@helper_cache = {}
      # This method is useful to avoid double call of heavy processing logic for tfvars,
      # since the tfvars files get evaluated twice.
      # Note: Not setting any cache or doing any logic unless resolved.
      def cache_helper(meth)
        puts "Deprecated cache_helper #{meth} called at:"
        lines = caller[0..3]
        puts lines
        line = lines.find { |l| l.include?("terraspace_plugin_") }
        md = line.match(%r{/(terraspace_plugin_.*?)(-|/)})
        plugin_name = md[1]
        puts <<~EOL
          This means the terraspace plugin used is out-of-date and
          should not be used with this version of terraspace #{Terraspace::VERSION}
          Recommend update it with

              bundle update #{plugin_name}

          EOL
        uncached_meth = "uncached_#{meth}"
        alias_method(uncached_meth, meth)
        define_method(meth) do |*args|
          return unless resolved? # return nil in first unresolved pass
          id = Marshal.dump([meth] + args)
          exist = @@helper_cache.key?(id)
          if exist
            @@helper_cache[id]
          else
            @@helper_cache[id] = send(uncached_meth, *args)
          end
        end
      end
    end
  end
end
