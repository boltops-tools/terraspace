## Stack Examples

    $ terraspace new test demo --type stack
    => Creating stack test: example
           exist  app/stacks/example
          create  app/stacks/example/test/.rspec
          create  app/stacks/example/test/Gemfile
          create  app/stacks/example/test/spec/fixtures/stack/main.tf
          create  app/stacks/example/test/spec/fixtures/stack/outputs.tf
          create  app/stacks/example/test/spec/main_spec.rb
          create  app/stacks/example/test/spec/spec_helper.rb
    $

## Module Examples

    $ terraspace new test example --type module
    => Creating module test: example
           exist  app/modules/example
          create  app/modules/example/test/.rspec
          create  app/modules/example/test/Gemfile
          create  app/modules/example/test/spec/fixtures/stack/main.tf
          create  app/modules/example/test/spec/fixtures/stack/outputs.tf
          create  app/modules/example/test/spec/main_spec.rb
          create  app/modules/example/test/spec/spec_helper.rb
    $

## Project Examples

    $ terraspace new test my --type project
    => Creating test bootstrap structure
           exist
          create  .rspec
          create  spec/spec_helper.rb
    $
