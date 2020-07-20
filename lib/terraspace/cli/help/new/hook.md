## Examples

Project-level hook:

    $ terraspace new hook --type project
          create  config/hooks
          create  config/hooks/terraform.rb

Stack-level hook:

    $ terraspace new hook demo --type stack
          create  app/stacks/demo/config/hooks
          create  app/stacks/demo/config/hooks/terraform.rb

Stack-level hook with kind option:

    $ terraspace new hook demo --type stack --kind terraspace
           exist  app/stacks/demo/config/hooks
          create  app/stacks/demo/config/hooks/terraspace.rb

Module-level hook:

    $ terraspace new hook example --type module
          create  app/modules/example/config/hooks
          create  app/modules/example/config/hooks/terraform.rb
