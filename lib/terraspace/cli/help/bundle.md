## Example

    terraspace bundle

## More commands

    terraspace bundle install     # same as bundle
    terraspace bundle update      # Updates Terrafile.lock
    terraspace bundle purge_cache # removes /tmp terraspace bundler folder

## Update a single module

    terraspace bundle update MODULE
    terraspace bundle update demo

## Info on a module

    terraspace bundle info MODULE

## Import Example As Stack

You can import a module's example as a stack.

    terraspace bundle example MODULE EXAMPLE