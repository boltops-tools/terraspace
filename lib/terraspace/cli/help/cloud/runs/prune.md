This leaves the top run alone. The top run usually starts immediately planning once the other runs are pruned. Runs that are also in "Needs Confirmation" will be cancelled.

## Examples

    terraspace cloud runs prune demo --noop
    terraspace cloud runs prune demo # live run

## Example with Output

    $ terraspace cloud runs prune pet
    Will keep:

        run-9muMrjrd22vhsP4u pending test 2020-09-18T12:47:11

    Will prune:

        run-fYTDzmKfCQf558UN pending test 2020-09-18T12:46:34
        run-6bgSTattJGpaRn9X pending test 2020-09-18T12:46:28
        run-jDHEtZb3vuFnuXqJ planned test 2020-09-18T12:38:35

    Are you sure? (y/N) y
    Cancelled run-fYTDzmKfCQf558UN test
    Cancelled run-6bgSTattJGpaRn9X test
    Discarded run-jDHEtZb3vuFnuXqJ test
    $