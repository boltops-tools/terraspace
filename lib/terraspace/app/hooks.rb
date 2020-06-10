class Terraspace::App
  class Hooks
    class_attribute :hooks
    self.hooks = {}

    def on_boot(&block)
      self.class.hooks[:on_boot] = block
    end

    class << self
      def run_hook(name)
        name = name.to_sym
        hook = hooks[name]
        hook.call if hook
      end
    end
  end
end
