## Example

    $ terraspace all output
    Running:
       terraspace output c1 # batch 1
       terraspace output b1 # batch 2
       terraspace output b2 # batch 2
       terraspace output a1 # batch 3
    Batch Run 1:
    Running: terraspace output c1 Logs: log/output/c1.log
    terraspace output c1:  length = 1
    Batch Run 2:
    Running: terraspace output b1 Logs: log/output/b1.log
    Running: terraspace output b2 Logs: log/output/b2.log
    terraspace output b1:  length = 1
    terraspace output b1:  length2 = 1
    terraspace output b2:  length = 1
    Batch Run 3:
    Running: terraspace output a1 Logs: log/output/a1.log
    terraspace output a1:  Warning: No outputs found
    Time took: 12s
    $