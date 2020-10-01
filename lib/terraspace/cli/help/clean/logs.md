## Examples

Remove logs completely:

    $ terraspace clean logs
    Will remove all the log files in log/ folder
    Are you sure? (y/N) y
    Removing all files in log/
    Logs removed

Truncate logs. IE: Keeps the files but removes contents and zero bytes the files.

    $ terraspace clean logs --truncate
    Will truncate all the log files in log/ folder
    Are you sure? (y/N) y
    Logs truncated
    $