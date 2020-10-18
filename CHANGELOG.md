# Change Log

All notable changes to this project will be documented in this file.
This project *loosely tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [0.4.1]
* #47 `terraspace list` fix and `terraspace all init` help updates

## [0.4.0]
* #46 improve hooks, bundle, auto init and bug fixes
* improve hooks: allow multiple hooks of same type, change path hooks/terraform.rb
* improve hooks: introduce terraspace-level as well as terraform-level hooks
* improve hooks: can take Ruby block or shell script
* improve auto init: reinit when module source changed, improve auto init: generalize retry check
* fix already_init? detection for case when stack does use module
* terraspace bundler options: can set any option now
* add `terraspace all init` command
* improve terraspace clean, prompt user and add `-y` option
* bundle: check if in terraspace project
* Rename NullObject to Unresolved
* improve error message when stacks not found. give `terraspace list` hint
* terraspace list. change default to `--type stack`
* change summary option to --details
* include terraspace version in generated Gemfile
* logs command to handle viewing, and clean logs to clean

## [0.3.6]
* #44 improve logs management commands: `terraspace logs remove` and `terraspace logs truncate`

## [0.3.5]
* #43 rename `terraform_output` helper to `output`. Keep `terraform_output` for backwards compatibility
* to_ruby natural interface to access output with full power of Ruby
* output formatters removed in favor for `.to_ruby` method.

## [0.3.4]
* #42 update cli docs and bug fixes
* fix console by using system instead of popen3
* fix build for edge case when app/modules exist but app/stacks do not
* terraspace new project: do not generate spec folder by default
* improve all output summary
* remove redundant `terraspace cloud setup`, instead use: `terraspace cloud sync`
* improve terraspace info output
* fix integration test pipeline

## [0.3.3]
* #41 fix `terraspace build` and `terraspace seed` when bucket doesnt exist yet and there are dependenices defined.

## [0.3.2]
* #40 fix backend auto creation

## [0.3.1]
* #39 fix backend auto creation

## [0.3.0]
* All commands: Dependency graph calculated and deployed in proper order
* All commands: `terraspace all up`, `terraspace all build`, `terraspace all down`, etc. `terraspace all -h`
* Terraspace log: view and tail log files
* Terraspace logs management commands: `terraspace logs truncate` and `terraspace logs remove`
* TFC/TFE: Improve support. `config.cloud.vars`, `config.cloud.workspace.attrs`
* TFC commands: terraspace cloud runs list, terraspace cloud runs prune
* TFC VCS also sync as part of deploy. Also separate `terraspace cloud sync` command
* Logger improvements: configurable formatter, log to stderr by default
* Rename: `cloud.relative_root` to `cloud.working_dir_prefix`
* Run a plan to capture the diff as part of `-y` option. IE: `terraspace up demo -y`
* Run plan -destroy as part of down -y
* Rename update cli to up. Only support the shorthand.
* Config options: config.all.concurrency, config.all.exit_on_fail, etc
* TFC: cloud.auto_sync option
* Improve terraform version check
* Terraform init: auto mode will retry initializing up to 3 times
* Terraspace seed: fix instance option

## [0.2.4]
* fix version check for some versions of terraform

## [0.2.3]
* #37 config.clean_cache option

## [0.2.2]
* #36 cloud.relative_root setting

## [0.2.1]
* #35 fix summary bug when ran multiple times with different envs

## [0.2.0]
* #34 Terraform Cloud and Terraform Enterprise support added.
* TFC Vars support: JSON and DSL. config.overwrite and config.overwrite_sensitive configs
* Build all stacks with config/terraform files. Designed to support the TFC VCS-driven workflow.
* Layer Interface module added. All latest provider plugins like terraspace\_plugin_aws make use of this module.
* Backend pattern expansion auto-detects the provider bakcend. The `expansion` method replaces the `backend_expand` method. `backend_expand` is deprecated.
* New expander variables: TYPE_INSTANCE, INSTANCE, CACHE_ROOT. Also added strip trailing - and / behavior.
* Timeout for terraform init. The default timeout is 10m and will then print out the terraform init log.
* Terraspace 0.2.x is compatible with terraspace\_plugin_aws 0.2.x, terraspace\_plugin_google 0.2.x, and terraspace\_plugin_azurerm 0.2.x
* New commands: terraspace list, terraspace cloud list, terraspace cloud setup, terraspace cloud destroy, terraspace new shim, terraspace new git_hook
* terraspace list: list of modules and stacks
* terraspace cloud list: shows list of TFC workspaces
* terraspace cloud setup: setups up TFC workspace for VCS-driven workflow. This automatically happens for the TFC CLI-driven workflow.
* terraspace cloud destroy: destroys the TFC workspace associated with the stack. Can also use the `terraspace down demo --destroy-workspace` option.
* terraspace new shim: An quick way to generate a terraspace shim.
* terraspace new git_hook: An quick way to set up a git pre-push hook for the TFC VCS-driven workflow.
* terraspace down: works even if there's no app/stacks folder. A fake stack is built.
* terraspace build: terraspace build placeholder concept.
* terraspace build: only builds now. auto bucket backend creation and terraform init is is still automatically called by terraform up, etc.
* terraspace up: --reconfigure option. This is useful if upgrading Terraform version.

## [0.1.2]
* #33 rspec-terraspace dependency added

## [0.1.1]
* #32 terraspace summary --short option

## [0.1.0]
* Initial release
