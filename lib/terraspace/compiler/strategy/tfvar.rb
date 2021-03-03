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

    def layer_paths
      Layer.new(@mod).paths
    end

    # Tact on number to ensure that tfvars will be processed in desired order.
    # Also name auto.tfvars so it will automatically load
    def ordered_name(layer_path)
      @order += 1
      prefix = @order.to_s
      # add leading 0 when more than 10 layers
      prefix = prefix.rjust(2, '0') if layer_paths.size > 9
      name = "#{prefix}-#{tfvar_name(layer_path)}"
      name.sub('.tfvars','.auto.tfvars')
          .sub('.rb','.auto.tfvars.json')
    end

    def tfvar_name(layer_path)
      if layer_path.include?('/tfvars/')
        name = layer_path.sub(%r{.*/tfvars/},'').gsub('/','-')
        name = "project-#{name}" if layer_path.include?("config/terraform/tfvars")
        name
      else
        File.basename(layer_path)
      end
    end

    def strategy_class(ext)
      "Terraspace::Compiler::Strategy::Tfvar::#{ext.camelize}".constantize
    rescue NameError
    end
  end
end
