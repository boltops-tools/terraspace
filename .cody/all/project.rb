github("boltops-tools/terraspace")
image("aws/codebuild/amazonlinux2-x86_64-standard:3.0")
env_vars(
  INFRACOST_API_KEY: "ssm:/#{Cody.env}/INFRACOST_API_KEY",
  TS_API: "ssm:/#{Cody.env}/TS_API",
  TS_COST: true,
  TS_LOG_LEVEL: "info",
  TS_ORG: "qa",
  TS_TOKEN: "ssm:/#{Cody.env}/TS_TOKEN",
)
