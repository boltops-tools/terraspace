## Example

    $ terraspace all graph
    Building graph...
    Graph saved to .terraspace-cache/graph/dependencies-20200919192103.png
    $

The graph will auto-open on macosx and cloud9.

![](https://img.boltops.com/boltops/tools/terraspace/graphs/example-a1.png)

## Text Form

You can also generate a graph in text, tree-like form

    $ terraspace all graph --format text
    a1
    ├── b2
    │   └── c1
    └── b1
        └── c1
