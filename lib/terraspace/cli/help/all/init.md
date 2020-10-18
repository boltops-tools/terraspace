## Example

    $ terraspace all init
    Building one stack to build all stacks
    Building .terraspace-cache/us-west-2/dev/stacks/c1
    Downloading tfstate files for dependencies defined in tfvars...
    Built in .terraspace-cache/us-west-2/dev/stacks/c1
    Running:
        terraspace init c1 # batch 1
        terraspace init b1 # batch 2
        terraspace init b2 # batch 2
        terraspace init a1 # batch 3
    Batch Run 1:
    Running: terraspace init c1 Logs: log/init/c1.log
    terraspace init c1:  Terraform has been successfully initialized!
    Batch Run 2:
    Running: terraspace init b1 Logs: log/init/b1.log
    Running: terraspace init b2 Logs: log/init/b2.log
    terraspace init b1:  Terraform has been successfully initialized!
    terraspace init b2:  Terraform has been successfully initialized!
    Batch Run 3:
    Running: terraspace init a1 Logs: log/init/a1.log
    terraspace init a1:  Terraform has been successfully initialized!
    Time took: 6s
    $

If Terraform is having trouble initializing, clearing the cache may help:

    $ terraspace clean cache -y
    Removed .terraspace-cache
    Removed /tmp/terraspace

Also consider disabling the [terraform.plugin_cache.enabled](https://terraspace.cloud/docs/config/reference/).
