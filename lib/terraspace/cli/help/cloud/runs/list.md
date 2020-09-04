## Example

Statuses of pending and planned are shown by default.

    $ terraspace cloud runs list pet
    +----------------------+---------+---------------------------------+---------------------+
    |          Id          | Status  |             Message             |     Created At      |
    +----------------------+---------+---------------------------------+---------------------+
    | run-AuTXsYU1svQEzQVg | pending | Queued manually using Terraform | 2020-09-18T11:30:41 |
    | run-LuwMibh3ebiG7KQZ | planned | test                            | 2020-09-17T23:16:36 |
    +----------------------+---------+---------------------------------+---------------------+
    $

To see all most recent runs, use `--status all`.

    $ terraspace cloud runs list pet --status all
    +----------------------+-----------+--------------------------------+---------------------+
    |          Id          |  Status   |            Message             |     Created At      |
    +----------------------+-----------+--------------------------------+---------------------+
    | run-LuwMibh3ebiG7KQZ | planned   | test 3                         | 2020-09-17T23:16:36 |
    | run-z9f67TNMRamZiGMR | canceled  | test 2                         | 2020-09-17T23:15:55 |
    | run-cN3CKT5po29p35Ta | discarded | test                           | 2020-09-17T22:24:31 |
    | run-rXMd7dm3fHvVsA36 | discarded | Queued from Terraform Cloud UI | 2020-09-17T20:00:20 |
    +----------------------+-----------+--------------------------------+---------------------+
    $

You can provide a list of statuses to the `--status` filter option.

    $ terraspace cloud runs list pet --status canceled discarded
    +----------------------+-----------+--------------------------------+---------------------+
    |          Id          |  Status   |            Message             |     Created At      |
    +----------------------+-----------+--------------------------------+---------------------+
    | run-gS2m1avc3U4j1fip | canceled  | test                           | 2020-09-17T23:15:43 |
    | run-ojwQ4r7MxuzyK3d9 | discarded | test                           | 2020-09-17T22:33:00 |
    | run-dczeLQsMc3ya4XnY | canceled  | test                           | 2020-09-17T22:32:55 |
    +----------------------+-----------+--------------------------------+---------------------+
