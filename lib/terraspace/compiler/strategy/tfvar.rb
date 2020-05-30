module Terraspace::Compiler::Strategy
  class Tfvar
    def initialize(mod)
      @mod = mod
      @order = 0
    end

    def run
      layer_paths.each do |layer_path|
        ext = File.extname(layer_path).sub('.','')
        klass = strategy_class(ext)
        next unless klass

        strategy = klass.new(@mod, layer_path)
        content = strategy.run

        dest_name = ordered_name(layer_path)
        writer = Terraspace::Compiler::Writer.new(@mod, dest_name: dest_name)
        writer.write(content)
      end
    end

    # Tact on number to ensure that tfvars will be processed in desired order.
    # Also name auto.tfvars so it will automatically load
    def ordered_name(layer_path)
      @order += 1
      name = "#{@order}-#{File.basename(layer_path)}"
      name.sub('.tfvars','.auto.tfvars')
          .sub('.rb','.auto.tfvars.json')
    end

    def layer_paths
      Layer.new(@mod).paths
    end

    def strategy_class(ext)
      "Terraspace::Compiler::Strategy::Tfvar::#{ext.camelize}".constantize
    rescue NameError
    end
  end
end
