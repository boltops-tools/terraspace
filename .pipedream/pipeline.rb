stage "Source" do
  github(
    Source: "boltops-tools/terraspace",
    # Branch: "master", # branch defaults to "master" or the `pipe deploy --branch` option
    AuthToken: ssm("/github/boltopsbot/token")
  )
end

stage "Build" do
  vars = env_vars(
    INFRACOST_API_KEY: "ssm:/#{Pipedream.env}/INFRACOST_API_KEY",
    TS_API: "ssm:/#{Pipedream.env}/TS_API",
    TS_LOG_LEVEL: "info",  # not ssm so can see in the codebuild logs
    TS_COST: true,
    TS_ORG: "qa",
    TS_TOKEN: "ssm:/#{Pipedream.env}/TS_TOKEN",
  )
  in_parallel do
    codebuild(Name: "terraspace-all", EnvironmentVariables: vars)
    codebuild(Name: "terraspace-aws", EnvironmentVariables: vars)
    codebuild(Name: "terraspace-azurerm", EnvironmentVariables: vars)
    codebuild(Name: "terraspace-google", EnvironmentVariables: vars)
    codebuild(Name: "terraspace-none", EnvironmentVariables: vars)
    codebuild(Name: "terraspace-unit") # does not have EnvironmentVariables
  end
end
