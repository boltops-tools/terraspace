Typically, Terraspace auto init should handle initialization. You can run init if you need to though.

## Example

    $ terraspace init demo
    Building .terraspace-cache/us-west-2/dev/stacks/demo
    Built in .terraspace-cache/us-west-2/dev/stacks/demo
    Current directory: .terraspace-cache/us-west-2/dev/stacks/demo
    => terraform init -get
    Initializing modules...

    Initializing the backend...

    Initializing provider plugins...
    - Using previously-installed hashicorp/aws v3.7.0
    - Using previously-installed hashicorp/random v2.3.0

    The following providers do not have any version constraints in configuration,
    so the latest version was installed.

    To prevent automatic upgrades to new major versions that may contain breaking
    changes, we recommend adding version constraints in a required_providers block
    in your configuration, with the constraint strings suggested below.

    * hashicorp/aws: version = "~> 3.7.0"
    * hashicorp/random: version = "~> 2.3.0"

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    $