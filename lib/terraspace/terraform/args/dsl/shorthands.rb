module Terraspace::Terraform::Args::Dsl
  module Shorthands
    COMMANDS_WITH_INPUT = %w[
      apply
      import
      init
      plan
      refresh
    ]

    COMMANDS_WITH_LOCKING = %w[
      apply
      destroy
      import
      init
      plan
      refresh
      taint
      untaint
    ]

    COMMANDS_WITH_PARALLELISM = %w[
      apply
      plan
      destroy
    ]

    COMMANDS_WITH_VARS = %w[
      apply
      console
      destroy
      import
      plan
      push
      refresh
    ]

    def shorthands
      {
        with_input: COMMANDS_WITH_INPUT,
        with_locking: COMMANDS_WITH_LOCKING,
        with_parallelism: COMMANDS_WITH_PARALLELISM,
        with_vars: COMMANDS_WITH_VARS,
      }
    end
  end
end
