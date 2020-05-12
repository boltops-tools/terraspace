command("init",
  arguments: ["-lock-timeout=20m"],
  env: {TF_VAR_var_from_environment: "value"},
)

command("apply",
  arguments: ["-lock-timeout=20m"],
  env: {TF_VAR_var_from_environment: "value"},
  var_files: ["a.tfvars", "b.tfvars"],
)
