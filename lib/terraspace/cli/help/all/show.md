## Example

    $ terraspace all show
    Running:
       terraspace show c1 # batch 1
       terraspace show b1 # batch 2
       terraspace show b2 # batch 2
       terraspace show a1 # batch 3
    Batch Run 1:
    Running: terraspace show c1 Logs: log/show/c1.log
    terraspace show c1: Resources: 0 Outputs: 1
    Batch Run 2:
    Running: terraspace show b1 Logs: log/show/b1.log
    Running: terraspace show b2 Logs: log/show/b2.log
    terraspace show b1: Resources: 0 Outputs: 2
    terraspace show b2: Resources: 0 Outputs: 1
    Batch Run 3:
    Running: terraspace show a1 Logs: log/show/a1.log
    terraspace show a1: Resources: 0 Outputs: 0
    Time took: 12s
    $