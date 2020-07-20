module Terraspace::Hooks
  module Concern
    def run_hooks(file, name, &block)
      hooks = Builder.new(@mod, file, name)
      hooks.build # build hooks
      hooks.run_hooks(&block)
    end
  end
end
