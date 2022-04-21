stage "Source" do
  github(
    Source: "boltops-tools/terraspace",
    # Branch: "master", # branch defaults to "master" or the `pipe deploy --branch` option
    AuthToken: ssm("/github/boltopsbot/token")
  )
end

stage "Build" do
  # in parallel
  codebuild(
    "terraspace-all",
    "terraspace-aws",
    "terraspace-azurerm",
    "terraspace-google",
    "terraspace-none",
    "terraspace-unit",
  )
end
