## Examples

Project-level arg:

    $ terraspace new arg --type project
          create  config/args
          create  config/args/terraform.rb

Stack-level arg:

    $ terraspace new arg demo --type stack
          create  app/stacks/demo/config/args
          create  app/stacks/demo/config/args/terraform.rb

Module-level arg:

    $ terraspace new arg example --type module
          create  app/modules/example/config/args
          create  app/modules/example/config/args/terraform.rb
