# Docs: https://terraspace.cloud/docs/config/reference/
Terraspace.configure do |config|
  config.logger.level = :info

  # To enable Terraspace Cloud set config.cloud.org
  # config.cloud.org = "ORG"          # required: replace with your org. only letters, numbers, underscore and dashes allowed
  # config.cloud.project = "main"     # optional. main is the default project name. only letters, numbers, underscore and dashes allowed

  # Uncomment to enable Cost Estimation. See: http://terraspace.cloud/docs/cloud/cost-estimation/
  # config.cloud.cost.enabled = true
end
