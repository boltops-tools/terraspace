## Example

    $ terraspace all up
    Will run:
       terraspace up c1 # batch 1
       terraspace up b1 # batch 2
       terraspace up b2 # batch 2
       terraspace up a1 # batch 3
    Are you sure? (y/N)

Once you confirm, Terraspace deploys the batches in parallel. Essentially, Terraspace handles the orchestration.

    Are you sure? (y/N) y
    Batch Run 1:
    Running: terraspace up c1 Logs: log/up/c1.log
    terraspace up c1:  Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
    Batch Run 2:
    Running: terraspace up b1 Logs: log/up/b1.log
    Running: terraspace up b2 Logs: log/up/b2.log
    terraspace up b1:  Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
    terraspace up b2:  Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
    Batch Run 3:
    Running: terraspace up a1 Logs: log/up/a1.log
    terraspace up a1:  Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
    Time took: 25s

Terraspace provides a reduced-noise summary of the runs. The full logs are also written for further inspection and debugging. The [terraspace log](https://terraspace.cloud/reference/terraspace-log/) command is useful for viewing the logs.

## Using Plans

Using plan output path. You can specify an output path for the plan that contains pattern for expansion. Example:

    $ terraspace all plan --out ":MOD_NAME.plan"

You can then use this later in terraspace up:

    $ terraspace all up --plan ":MOD_NAME.plan"
