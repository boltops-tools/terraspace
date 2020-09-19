## Example

    $ terraspace all down
    Will run:
       terraspace down a1 # batch 1
       terraspace down b1 # batch 2
       terraspace down b2 # batch 2
       terraspace down c1 # batch 3
    Are you sure? (y/N)

Once you confirm, Terraspace destroys the infrastructure.

    Are you sure? (y/N) y
    Batch Run 1:
    Running: terraspace down a1 Logs: log/down/a1.log
    terraspace down a1:  Changes to Outputs:
    terraspace down a1:  Destroy complete! Resources: 2 destroyed.
    Batch Run 2:
    Running: terraspace down b1 Logs: log/down/b1.log
    Running: terraspace down b2 Logs: log/down/b2.log
    terraspace down b1:  Changes to Outputs:
    terraspace down b1:  Destroy complete! Resources: 2 destroyed.
    terraspace down b2:  Changes to Outputs:
    terraspace down b2:  Destroy complete! Resources: 1 destroyed.
    Batch Run 3:
    Running: terraspace down c1 Logs: log/down/c1.log
    terraspace down c1:  Changes to Outputs:
    terraspace down c1:  Destroy complete! Resources: 1 destroyed.
    Time took: 15s
    $

Terraspace provides a reduced-noise summary of the runs. The full logs are also written for further inspection and debugging. The [terraspace log](https://terraspace.cloud/reference/terraspace-log/) command is useful for viewing the logs.
