class Terraspace::Compiler::Strategy::Tfvar
  class Layer
    def initialize(mod)
      @mod = mod
    end

    def paths
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

    # Layers in order
    #
    #     Name                  | Pattern                      | Example
    #     ----------------------|------------------------------|---------------
    #     base                  | base                         | base.tfvars
    #     env                   | env                          | dev.tfvars
    #     region base           | region/base                  | us-west-2/base.tfvars (provider specific)
    #     region env            | region/env                   | us-west-2/dev.tfvars (provider specific)
    #     provider base         | provider/base                | aws/base.tfvars (provider specific)
    #     provider env          | provider/env                 | aws/dev.tfvars (provider specific)
    #     provider base         | provider/region/base         | aws/us-west-2/base.tfvars (provider specific)
    #     provider env          | provider/region/env          | aws/us-west-2/dev.tfvars (provider specific)
    #     provider account base | provider/account/region/base | aws/112233445566/us-west-2/base.tfvars (provider specific)
    #     provider account env  | provider/account/region/env  | aws/112233445566/us-west-2/dev.tfvars (provider specific)
    #
    # Note the account depends on the provider. IE: For aws its account. For google, account maps to the project.
    #
    def layers
      ["base", Terraspace.env] + provider_layers
    end

    def provider_layers
      layers = []
      Terraspace::Provider.layer_classes.each do |klass|
        layer = klass.new

        # flatten because its simpler and the more common case is a single provider
        layers << "#{layer.region}/base"
        layers << "#{layer.region}/#{Terraspace.env}"

        # in case using multiple providers and one region
        layers << "#{layer.provider}/base"
        layers << "#{layer.provider}/#{Terraspace.env}"

        # in case another provider has colliding regions
        layers << "#{layer.provider}/#{layer.region}/base"
        layers << "#{layer.provider}/#{layer.region}/#{Terraspace.env}"

        # in case mapping env is not mapped to account
        layers << "#{layer.provider}/#{layer.account}/#{layer.region}/base"
        layers << "#{layer.provider}/#{layer.account}/#{layer.region}/#{Terraspace.env}"
      end
      layers
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
      return mod_dir if @mod.type == "module"

      Dir.glob("#{seed_dir}/*").empty? ? mod_dir : seed_dir
    end

  end
end
