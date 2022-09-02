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
      project_paths = full_paths(config_tfvars_dir)
      stack_paths   = full_paths(app_tfvars_dir)
      paths = (project_paths + stack_paths).uniq
      show_layers(paths)
      paths.select do |path|
        File.exist?(path)
      end
    end
    memoize :paths

    def full_paths(tfvars_dir)
      layers = full_layering(tfvars_dir, remove_first: true)
      if Terraspace.role
        layers += full_layering("#{tfvars_dir}/#{Terraspace.role}")
      end
      if Terraspace.app
        layers += full_layering("#{tfvars_dir}/#{Terraspace.app}")
      end
      if Terraspace.app && Terraspace.role
        layers += full_layering("#{tfvars_dir}/#{Terraspace.app}/#{Terraspace.role}")
      end
      layers
    end

    def full_layering(tfvars_dir, remove_first: false)
      # layers defined in Terraspace::Layering module
      all = layers.map { |layer| layer.sub(/\/$/,'') } # strip trailing slash
      all = all.inject([]) do |sum, layer|
        sum += layer_levels(layer) unless layer.nil?
        sum
      end
      all = all.reject { |layer| layer.ends_with?('-') }
      all.map! do |layer|
        layer = layer.blank? ? layer : "/#{layer}"
        [
          "#{tfvars_dir}#{layer}.tfvars",
          "#{tfvars_dir}#{layer}.rb",
        ]
      end.flatten!
      all.shift if remove_first # IE: app/stacks/demo/tfvars.tfvars
      all
    end

    # adds prefix and to each layer pair that has base and Terraspace.env. IE:
    #
    #    "#{prefix}/base"
    #    "#{prefix}/#{Terraspace.env}"
    #
    def layer_levels(prefix=nil)
      if @mod.instance
        logger.info "WARN: The instance option is deprecated. Instead use TS_EXTRA"
        logger.info "See: http://terraspace.test/docs/layering/instance-option/"
      end
      extra = Terraspace.extra || @mod.instance
      levels = ["base", Terraspace.env, extra, "#{Terraspace.env}-#{extra}"].reject(&:blank?) # layer levels. @mod.instance can be nil
      levels.map! do |i|
        # base layer has prefix of '', reject with blank so it doesnt produce '//'
        [prefix, i].reject(&:blank?).join('/')
      end
      levels.unshift(prefix) if !prefix.nil?
      levels
    end

    def plugins
      layers = []
      Terraspace::Plugin.layer_classes.each do |klass|
        layer = klass.new

        # region is high up because its simpler and the more common case is a single provider
        layers << layer.region

        namespace = friendly_name(layer.namespace)
        mode = Terraspace.config.layering.mode # simple, namespace, provider
        if mode == "namespace" || mode == "provider"
          # namespace is a simple way keep different tfvars between different engineers on different accounts
          layers << namespace
          layers << "#{namespace}/#{layer.region}"
        end

        if mode == "provider"
          # in case using multiple providers and one region
          layers << layer.provider
          layers << "#{layer.provider}/#{layer.region}" # also in case another provider has colliding regions

          # Most general layering
          layers << "#{layer.provider}/#{namespace}"
          layers << "#{layer.provider}/#{namespace}/#{layer.region}"
        end
      end
      layers
    end

    # IE: config/stacks/demo/tfvars
    def config_tfvars_dir
      "#{Terraspace.root}/config/#{@mod.build_dir(disable_extra: true)}/tfvars"
    end

    # IE: app/stacks/demo/tfvars
    def app_tfvars_dir
      "#{@mod.root}/tfvars"
    end

    @@shown_layers = {}
    def show_layers(paths)
      return unless @mod.resolved
      return if @@shown_layers[@mod.name]
      logger.debug "Layers for #{@mod.name}:"
      show = Terraspace.config.layering.show || ENV['TS_LAYERING_SHOW_ALL']
      paths.each do |path|
        next if ARGV[0] == "all" # dont show layers with all command since fork happens after build
        next unless path.include?('.tfvars')
        if ENV['TS_LAYERING_SHOW_ALL']
          message = "    #{pretty_path(path)}"
          message = "#{message} (found)".color(:yellow) if File.exist?(path)
          logger.info message
        elsif show
          logger.info "    #{pretty_path(path)}" if File.exist?(path)
        end
      end
      # do not logger.info "" it creates a newline with all
      @@shown_layers[@mod.name] = true
    end
  end
end
