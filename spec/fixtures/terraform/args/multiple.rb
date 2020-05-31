command("init", "apply",
  args: ["-lock-timeout=20m"],
  env: {TF_VAR_var_from_environment: "value"},
)
