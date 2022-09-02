## Examples

    terraspace state demo list
    terraspace state demo mv
    terraspace state demo pull
    terraspace state demo push
    terraspace state demo replace
    terraspace state demo rm
    terraspace state demo show

## Args Straight Delegation

The `terraspace state` command delegates to the `terraform state` commands passing the arguments straight through. Refer to the underlying `terraform` command help for arguments.  Example:

    terraform state list -h
    ...
    Options:
    ...
    -id=ID              Filters the results to include only instances whose
                          resource types have an attribute named "id" whose value
                          equals the given id string.

This means we can use the `-id` or `--id` option and terraspace will pass it straight through. Example:

    terraspace state demo list --id enabled-bull
    Building .terraspace-cache/us-west-2/dev/stacks/demo
    Built in .terraspace-cache/us-west-2/dev/stacks/demo
    Current directory: .terraspace-cache/us-west-2/dev/stacks/demo
    => terraform state list --id enabled-bull
    random_pet.this
