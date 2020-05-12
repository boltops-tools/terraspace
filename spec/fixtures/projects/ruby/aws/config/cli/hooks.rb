before("apply", "init",
  execute: "echo2 hi",
  exit_on_fail: false,
)

after("apply", "init",
  execute: "echo bye"
)
