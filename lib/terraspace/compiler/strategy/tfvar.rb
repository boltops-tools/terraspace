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

    def layers
      # TODO: add instance and env/instance layers
      ["base", Terraspace.env]
    end

    def layer_paths
      layer_paths = layers.map do |layer|
        [
          "#{tfvars_dir}/#{layer}.rb",
          "#{tfvars_dir}/#{layer}.tfvars",
        ]
      end.flatten

      layer_paths.select do |path|
        File.exist?(path)
      end
    end

    # seed dir takes higher precedence than the tfvars folder within the stack module. Example:
    #
    #     seed/tfvars/stacks/core (folder must have *.tfvars or *.rb files)
    #     app/stacks/core/tfvars
    #
    # This allows user to take over the tfvars embedded in the stack if they need to. Generally,
    # putting tfvars in within the app/stacks/MOD/tfvars folder seems cleaner and easier to follow.
    #
    # Do not consider app/modules at all. Encourage modules to be reuseable instead. Stacks are ok
    # to have business logic and tfvars.
    #
    def tfvars_dir
      seed_dir = "#{Terraspace.root}/seed/tfvars/#{@mod.build_dir}"
      mod_dir = "#{@mod.root}/tfvars"

      # Do not consider tfvars files under the app/modules path at all.
      # Encourage users to treat modules as reusable libraries.
      return seed_dir if @mod.type == "module"

      Dir.glob("#{seed_dir}/*").empty? ? mod_dir : seed_dir
    end

    def strategy_class(ext)
      "Terraspace::Compiler::Strategy::Tfvar::#{ext.camelize}".constantize rescue nil
    end
  end
end
