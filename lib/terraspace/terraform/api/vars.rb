class Terraspace::Terraform::Api
  class Vars
    extend Memoist
    include Client

    def initialize(mod, workspace)
      @mod, @workspace = mod, workspace
    end

    def run
      return unless exist?

      vars = vars_class.new(@mod, vars_path).vars
      vars.each do |attrs|
        Var.new(@workspace, attrs).sync
      end
    end

    # Return value examples:
    #
    #     Terraspace::Terraform::Api::Vars::Json
    #     Terraspace::Terraform::Api::Vars::Rb
    #
    def vars_class
      ext = File.extname(vars_path).sub('.','')
      "Terraspace::Terraform::Api::Vars::#{ext.camelize}".constantize
    end

    def exist?
      !!vars_path
    end

    def vars_path
      # .rb takes higher precedence
      Dir.glob("#{Terraspace.root}/config/terraform/cloud/vars.{rb,json}").first
    end
  end
end
