## Examples

    terraspace state list demo
    terraspace state mv demo
    terraspace state pull demo
    terraspace state push demo
    terraspace state replace demo
    terraspace state rm demo
    terraspace state show demo

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

    terraspace state list demo --id enabled-bull
    Building .terraspace-cache/us-west-2/dev/stacks/demo
    Built in .terraspace-cache/us-west-2/dev/stacks/demo
    Current directory: .terraspace-cache/us-west-2/dev/stacks/demo
    => terraform state list --id enabled-bull
    random_pet.this
