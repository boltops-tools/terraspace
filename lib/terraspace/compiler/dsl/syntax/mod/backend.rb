module Terraspace::Compiler::Dsl::Syntax::Mod
  module Backend
    def backend(name, props={})
      terraform = @structure[:terraform] ||= {}
      backend = terraform[:backend] ||= {}
      backend[name] = props
    end

    # Useful for s3 backend:
    #
    #     backend("s3",
    #       bucket:         "my-bucket",
    #       key:            default_state_path, # IE: development/modules/vm/terraform.tfstate
    #       region:         "us-west-2",
    #       encrypt:        true,
    #       dynamodb_table: default_lock_table, # terraform_locks
    #     )
    #
    # Return value examples:

    #
    #     development/modules/instance/terraform.tfstate
    #     development/modules/vpc/terraform.tfstate
    #     development/stacks/core/terraform.tfstate
    #
    def default_state_path
      "#{default_state_prefix}/terraform.tfstate"
    end

    def default_lock_table
      "terraform_locks"
    end

    # Useful for gcs backend:
    #
    #     backend("gcs",
    #       bucket: "terraspace-state",
    #       prefix: default_state_prefix, # IE: development/modules/vm => development/modules/vm/default.tfstate
    #     )
    #
    # Return value examples:
    #
    #     development/modules/instance
    #     development/modules/vpc
    #     development/stacks/core
    #
    def default_state_prefix
      "#{Terraspace.env}/#{@mod.type_dir}/#{@mod.name}"
    end
  end
end
