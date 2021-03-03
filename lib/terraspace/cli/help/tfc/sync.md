## Examples

Sync all stacks:

    $ terraspace tfc sync
    About to sync these project stacks with Terraform Cloud workspaces:

        Stack => Workspace
        demo => demo-dev-us-west-2
        demo2 => demo2-dev-us-west-2

    A sync does the following for each workspace:

      1. Create or update workspace, including the VCS settings.
      2. Set the working dir.
      3. Set env and terraform variables.

    Are you sure? (y/N) y
    Syncing to Terraform Cloud: demo => demo-dev-us-west-2
    Syncing to Terraform Cloud: demo2 => demo2-dev-us-west-2
    $

Sync specific stacks:

    $ terraspace tfc sync demo
    About to sync these project stacks with Terraform Cloud workspaces:

        Stack => Workspace
        demo => demo-dev-us-west-2

    A sync does the following for each workspace:

      1. Create or update workspace, including the VCS settings.
      2. Set the working dir.
      3. Set env and terraform variables.

    Are you sure? (y/N) y
    Syncing to Terraform Cloud: demo => demo-dev-us-west-2
    $

Can also specify multiple stacks:

    terraspace tfc sync demo demo2
