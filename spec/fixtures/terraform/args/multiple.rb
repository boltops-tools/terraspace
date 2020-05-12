command("init", "apply",
  arguments: ["-lock-timeout=20m"],
  env: {TF_VAR_var_from_environment: "value"},
)
