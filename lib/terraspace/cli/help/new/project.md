## Example

    $ terraspace new project infra --plugin aws --examples
    => Creating new project called infra.
          create  infra
          create  infra/.gitignore
          create  infra/Gemfile
          create  infra/README.md
          create  infra/Terrafile
          create  infra/config/app.rb
           exist  infra
          create  infra/config/terraform/backend.tf
          create  infra/config/terraform/provider.tf
    => Creating test for new module: example
          create  infra/app/modules/example
          create  infra/app/modules/example/main.tf
          create  infra/app/modules/example/outputs.tf
          create  infra/app/modules/example/variables.tf
    => Creating new stack called demo.
          create  infra/app/stacks/demo
          create  infra/app/stacks/demo/main.tf
          create  infra/app/stacks/demo/outputs.tf
          create  infra/app/stacks/demo/variables.tf
    => Creating test bootstrap structure
           exist  infra
          create  infra/.rspec
          create  infra/spec/spec_helper.rb
    => Installing dependencies with: bundle install
    Bundle complete! 3 Gemfile dependencies, 88 gems now installed.
    Use `bundle info [gemname]` to see where a bundled gem is installed.
    ================================================================
    Congrats! You have successfully created a terraspace project.
    Check out the created files. Adjust to the examples and then deploy with:

        cd infra
        terraspace up demo -y   # to deploy
        terraspace down demo -y # to destroy

    More info: https://terraspace.cloud/
    $