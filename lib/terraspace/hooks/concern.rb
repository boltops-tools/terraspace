module Terraspace::Hooks
  module Concern
    def run_hooks(dsl_file, name, &block)
      hooks = Builder.new(@mod, "#{Terraspace.root}/config/hooks/#{dsl_file}", name)
      hooks.build # build hooks
      hooks.run_hooks(&block)
    end
  end
end
