stage "Source" do
  github(
    source: "boltops-tools/terraspace",
    # branch: "master", # branch defaults to "master" or the `pipe deploy --branch` option
    auth_token: ssm("/github/boltopsbot/token")
  )
end

stage "Build" do
  # in parallel
  codebuild(
    "terraspace-aws",
    "terraspace-azurerm",
    "terraspace-google",
    "terraspace-unit",
  )
end
