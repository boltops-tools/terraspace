## Example

    $ terraspace all plan
    Running:
       terraspace plan c1 # batch 1
       terraspace plan b1 # batch 2
       terraspace plan b2 # batch 2
       terraspace plan a1 # batch 3
    Batch Run 1:
    Running: terraspace plan c1 Logs: log/plan/c1.log
    terraspace plan c1:  Plan: 1 to add, 0 to change, 0 to destroy.
    terraspace plan c1:  Changes to Outputs:
    Batch Run 2:
    Running: terraspace plan b1 Logs: log/plan/b1.log
    Running: terraspace plan b2 Logs: log/plan/b2.log
    terraspace plan b1:  Plan: 2 to add, 0 to change, 0 to destroy.
    terraspace plan b1:  Changes to Outputs:
    terraspace plan b2:  Plan: 1 to add, 0 to change, 0 to destroy.
    terraspace plan b2:  Changes to Outputs:
    Batch Run 3:
    Running: terraspace plan a1 Logs: log/plan/a1.log
    terraspace plan a1:  Plan: 2 to add, 0 to change, 0 to destroy.
    terraspace plan a1:  Changes to Outputs:
    Time took: 11s
    $