## Example

    $ terraspace all validate
    Running:
       terraspace validate c1 # batch 1
       terraspace validate b1 # batch 2
       terraspace validate b2 # batch 2
       terraspace validate a1 # batch 3
    Batch Run 1:
    Running: terraspace validate c1 Logs: log/validate/c1.log
    terraspace validate c1:  Success! The configuration is valid.
    Batch Run 2:
    Running: terraspace validate b1 Logs: log/validate/b1.log
    Running: terraspace validate b2 Logs: log/validate/b2.log
    terraspace validate b1:  Success! The configuration is valid.
    terraspace validate b2:  Success! The configuration is valid.
    Batch Run 3:
    Running: terraspace validate a1 Logs: log/validate/a1.log
    terraspace validate a1:  Success! The configuration is valid.
    Time took: 13s
    $