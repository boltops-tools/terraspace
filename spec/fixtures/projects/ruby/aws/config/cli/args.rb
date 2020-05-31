command("init",
  args: ["-lock-timeout=21m"],
  env: {TF_VAR_var_from_environment: "value"},
  var_files: ["a.tfvars", "b.tfvars"],
)

command("apply",
  args: ["-lock-timeout=22m"],
  env: {TF_VAR_var_from_environment: "value"},
  var_files: ["a.tfvars", "b.tfvars"],
)
