class Terraspace::Compiler::Strategy::Tfvar
  class Layer
    def initialize(mod)
      @mod = mod
    end

    def paths
      layer_paths = layers.map do |layer|
        [
          "#{tfvars_dir}/#{layer}.tfvars",
          "#{tfvars_dir}/#{layer}.rb",
        ]
      end.flatten

      layer_paths.select do |path|
        File.exist?(path)
      end
    end

    # Layers in order
    #
    #     Name / Pattern                 | Example
    #     -------------------------------|---------------
    #     base                           | base.tfvars
    #     env                            | dev.tfvars
    #     region/base                    | us-west-2/base.tfvars (provider specific)
    #     region/env                     | us-west-2/dev.tfvars (provider specific)
    #     namespace/base                 | 112233445566/base.tfvars (provider specific)
    #     namespace/env                  | 112233445566/dev.tfvars (provider specific)
    #     namespace/region/base          | 112233445566/us-west-2/base.tfvars (provider specific)
    #     namespace/region/env           | 112233445566/us-west-2/dev.tfvars (provider specific)
    #     provider/base                  | aws/base.tfvars (provider specific)
    #     provider/env                   | aws/dev.tfvars (provider specific)
    #     provider/region/base           | aws/us-west-2/base.tfvars (provider specific)
    #     provider/region/env            | aws/us-west-2/dev.tfvars (provider specific)
    #     provider/namespace/base        | aws/112233445566/base.tfvars (provider specific)
    #     provider/namespace/env         | aws/112233445566/dev.tfvars (provider specific)
    #     provider/namespace/region/base | aws/112233445566/us-west-2/base.tfvars (provider specific)
    #     provider/namespace/region/env  | aws/112233445566/us-west-2/dev.tfvars (provider specific)
    #
    # namespace and region depends on the provider. Here an example of the mapping:
    #
    #              | AWS     | Azure        | Google
    #    ----------|---------|--------------|-------
    #    namespace | account | subscription | project
    #    region    | region  | location     | region
    #
    #
    def layers
      layer_pair + plugin_layers
    end

    def plugin_layers
      layers = []
      Terraspace::Plugin.layer_classes.each do |klass|
        layer = klass.new

        # region is high up because its simpler and the more common case is a single provider
        layers += layer_pair(layer.region)

        # namespace is a simple way keep different tfvars between different engineers on different accounts
        layers += layer_pair(layer.namespace)
        layers += layer_pair("#{layer.namespace}/#{layer.region}")

        # in case using multiple providers and one region
        layers += layer_pair(layer.provider)
        layers += layer_pair("#{layer.provider}/#{layer.region}") # also in case another provider has colliding regions

        # Most general layering
        layers += layer_pair("#{layer.provider}/#{layer.namespace}")
        layers += layer_pair("#{layer.provider}/#{layer.namespace}/#{layer.region}")
      end
      layers
    end

    # adds prefix and to each layer pair that has base and Terraspace.env. IE:
    #
    #    "#{prefix}/base"
    #    "#{prefix}/#{Terraspace.env}"
    #
    def layer_pair(prefix=nil)
      pair = ["base", Terraspace.env] # layer pairs
      pair.map do |i|
        [prefix, i].compact.join('/')
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

      # Do not consider tfvars files under the app/modules path at all, only consider seed_dir
      # Encourage users to treat modules as reusable libraries.
      return seed_dir if @mod.type == "module"

      Dir.glob("#{seed_dir}/*").empty? ? mod_dir : seed_dir
    end

  end
end
