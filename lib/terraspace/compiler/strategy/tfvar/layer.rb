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
class Terraspace::Compiler::Strategy::Tfvar
  class Layer
    extend Memoist
    include Terraspace::Layering
    include Terraspace::Plugin::Expander::Friendly
    include Terraspace::Util

    def initialize(mod)
      @mod = mod
    end

    def paths
      project_paths = full_paths(project_tfvars_dir)
      stack_paths   = full_paths(stack_tfvars_dir)
      paths = project_paths + stack_paths
      show_layers(paths)
      paths.select do |path|
        File.exist?(path)
      end
    end
    memoize :paths

    def full_paths(tfvars_dir)
      layer_paths = full_layering.map do |layer|
        [
          "#{tfvars_dir}/#{layer}.tfvars",
          "#{tfvars_dir}/#{layer}.rb",
        ]
      end.flatten
    end

    def full_layering
      # layers defined in Terraspace::Layering module
      all = layers.map { |layer| layer.sub(/\/$/,'') } # strip trailing slash
      all.inject([]) do |sum, layer|
        sum += layer_levels(layer) unless layer.nil?
        sum
      end
    end

    # adds prefix and to each layer pair that has base and Terraspace.env. IE:
    #
    #    "#{prefix}/base"
    #    "#{prefix}/#{Terraspace.env}"
    #
    def layer_levels(prefix=nil)
      levels = ["base", Terraspace.env, @mod.instance].reject(&:blank?) # layer levels. @mod.instance can be nil
      env_levels = levels.map { |l| "#{Terraspace.env}/#{l}" } # env folder also
      levels = levels + env_levels
      levels.map! do |i|
        # base layer has prefix of '', reject with blank so it doesnt produce '//'
        [prefix, i].reject(&:blank?).join('/')
      end
      levels.unshift(prefix) unless prefix.blank? # IE: tfvars/us-west-2.tfvars
      levels
    end

    def plugins
      layers = []
      Terraspace::Plugin.layer_classes.each do |klass|
        layer = klass.new

        # region is high up because its simpler and the more common case is a single provider
        layers << layer.region

        namespace = friendly_name(layer.namespace)

        # namespace is a simple way keep different tfvars between different engineers on different accounts
        layers << namespace
        layers << "#{namespace}/#{layer.region}"

        # in case using multiple providers and one region
        layers << layer.provider
        layers << "#{layer.provider}/#{layer.region}" # also in case another provider has colliding regions

        # Most general layering
        layers << "#{layer.provider}/#{namespace}"
        layers << "#{layer.provider}/#{namespace}/#{layer.region}"
      end
      layers
    end

    def project_tfvars_dir
      "#{Terraspace.root}/config/terraform/tfvars"
    end

    # seed dir takes higher precedence than the tfvars folder within the stack module. Example:
    #
    #     seed/tfvars/stacks/demo (folder must have *.tfvars or *.rb files)
    #     app/stacks/demo/tfvars
    #
    # This allows user to take over the tfvars embedded in the stack if they need to. Generally,
    # putting tfvars in within the app/stacks/MOD/tfvars folder seems cleaner and easier to follow.
    #
    # Will also consider app/modules/demo/tfvars. Though modules to be reuseable and stacks is where business logic
    # should go.
    #
    def stack_tfvars_dir
      seed_dir = "#{Terraspace.root}/seed/tfvars/#{@mod.build_dir(disable_instance: true)}"
      mod_dir = "#{@mod.root}/tfvars"

      empty = Dir.glob("#{seed_dir}/*").empty?
      empty ? mod_dir : seed_dir
    end

    @@shown_layers = {}
    def show_layers(paths)
      return unless @mod.resolved
      return if @@shown_layers[@mod.name]
      logger.debug "Layers for #{@mod.name}:"
      paths.each do |path|
        logger.debug "    #{pretty_path(path)}" if File.exist?(path) || ENV['TS_SHOW_ALL_LAYERS']
      end
      logger.debug ""
      @@shown_layers[@mod.name] = true
    end

  end
end
