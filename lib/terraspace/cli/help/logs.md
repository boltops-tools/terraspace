The log commands will filter out the logs for the last ran terraspace command. It does this by filtering for the last found PID in the log files.

## Quick Start

Follow all the logs as you're running `terraspace all up`:

    terraspace logs -f

Note, Terraspace automatically checks every second for new logs and adds them to be followed.

## View Logs

View last 10 lines of each log file.

    terraspace logs up network # view up log on a specific stack
    terraspace logs up         # view all up logs
    terraspace logs down       # view all down logs
    terraspace logs            # view all logs: up, down, etc

By default, the logs command shows the last 10 lines for each log file. You can use the `-n` option to adjust this.

    terraspace logs -n 2       # view last 2 lines of all logs: up, down, etc

To show all logs, use the `-a` option.

    terraspace logs up -a

Note, if both an action and stack is specified, then it defaults to showing all logs. If you want not to show all logs, use `--no-all`.

## Tail Logs

To tail logs, use the `-f` option.

    terraspace logs up network -f # view up log on a specific stack
    terraspace logs up -f         # view all up logs
    terraspace logs down -f       # view all down logs
    terraspace logs -f            # view all logs: up, down, etc

## Timestamps

The timestamps are shown by default when you are looking for multiple files.  When you specify both the action and stack for a single log file, the timestamps are not shown.

    terraspace logs up         # timestamps will be shown in this case
    terraspace logs up network # timestamps not be shown in this case

To show timestamps:

    terraspace logs up network --timestamps
