command("init",
  arguments: ["-lock-timeout=21m"],
  env: {TF_VAR_var_from_environment: "value"},
  var_files: ["a.tfvars", "b.tfvars"],
)

command("apply",
  arguments: ["-lock-timeout=22m"],
  env: {TF_VAR_var_from_environment: "value"},
  var_files: ["a.tfvars", "b.tfvars"],
)
