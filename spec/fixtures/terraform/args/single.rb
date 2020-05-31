command("init",
  args: ["-lock-timeout=20m"],
  env: {TF_VAR_var_from_environment: "value"},
)

command("apply",
  args: ["-lock-timeout=20m"],
  env: {TF_VAR_var_from_environment: "value"},
  var_files: ["a.tfvars", "b.tfvars"],
)
