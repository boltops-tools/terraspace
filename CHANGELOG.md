# Change Log

All notable changes to this project will be documented in this file.
This project *loosely tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [0.6.5] - 2021-03-24
- [#96](https://github.com/boltops-tools/terraspace/pull/96) terraspace fmt: ability to specific module or stack

## [0.6.4] - 2021-03-22
- [#94](https://github.com/boltops-tools/terraspace/pull/94) terraspace fmt command

## [0.6.3] - 2021-03-12
- [#91](https://github.com/boltops-tools/terraspace/pull/91) Camelcase
- [#92](https://github.com/boltops-tools/terraspace/pull/92) disable terraform.plugin_cache by default
- skip build config/helpers

## [0.6.2] - 2021-03-05
- [#90](https://github.com/boltops-tools/terraspace/pull/90) Boot hooks: new and improved boot hooks interface
- remove old config.hooks.on_boot

## [0.6.1] - 2021-03-04
- [#89](https://github.com/boltops-tools/terraspace/pull/89) rename option to enable_names.expansion

## [0.6.0] - 2021-03-03
- [#87](https://github.com/boltops-tools/terraspace/pull/87) rename cloud to tfc command and improvements
- [#88](https://github.com/boltops-tools/terraspace/pull/88) custom layering support
- Improve stdout handling, so this works: `terraspace show demo --json | jq`
- `terraspace plan --output plan.save` writes to relative cache path.
- `terraspace up --plan plan.save` copies plan.save to cache path.
- Add state command. Initial simple version.

## [0.5.12] - 2021-02-27
- [#79](https://github.com/boltops-tools/terraspace/pull/79) Fix syntax issue
- [#85](https://github.com/boltops-tools/terraspace/pull/85) Add all.include_stacks option and fix all.ignore_stacks option when building dependency graph

## [0.5.11] - 2021-02-11
- [#76](https://github.com/boltops-tools/terraspace/pull/76) dont use auto generated plan when both yes and plan options used
- fix plan path when 2 stacks of same name run at the same time

## [0.5.10] - 2020-12-11
- [#69](https://github.com/boltops-tools/terraspace/pull/69) require singleton earlier

## [0.5.9] - 2020-12-11
- [#68](https://github.com/boltops-tools/terraspace/pull/68) require singleton
- fix graphviz check for format text, improve graphviz install help message

## [0.5.8] - 2020-12-04
- [#67](https://github.com/boltops-tools/terraspace/pull/67) fix find placeholder stack so config/terraform only builds for stacks

## [0.5.7] - 2020-12-02
- [#64](https://github.com/boltops-tools/terraspace/pull/64) fix completion_script

## [0.5.6] - 2020-11-30
- [#61](https://github.com/boltops-tools/terraspace/pull/61) allow envs and regions check feature
- fix terraspace build before hook

## [0.5.5] - 2020-11-27
- fix link

## [0.5.4] - 2020-11-27
- fix check setup when terraform not found

## [0.5.3] - 2020-11-27
- [#60](https://github.com/boltops-tools/terraspace/pull/60) fix terraspace check_setup, use type and allow to run outside project
- improve terraform is not installed message

## [0.5.2] - 2020-11-27
- [#59](https://github.com/boltops-tools/terraspace/pull/59) only run bundler/setup within terraspace project and check standalone install
- fix terraspace help
- fix terraspace setup check when terraform is not installed

## [0.5.1] - 2020-11-17
- [#56](https://github.com/boltops-tools/terraspace/pull/56) fix arg and hook generators
- fix ci build

## [0.5.0] - 2020-11-15
- [#55](https://github.com/boltops-tools/terraspace/pull/55) custom helpers support
- plugin helpers support: aws_secret, aws_ssm, google_secret, etc
- introduce stack-level test concept and change project-level test concept
- generators: standardize and unifiy new test
- new generators: arg, hook, helper
- clean up Terraspace check project
- setup up autoloader and bundler/setup earlier. removes need for shim
- test generator plugin autodetection
- remove internal run_generator_hook_script
- stack-level args customization support
- improve test output noise-level
- new setting: config.terraform.plugin_cache.purge_on_error
- quiet option for project generator

## [0.4.4]
- #50 retry logic for shared cache error
- #51 fix cloud sync: call build first

## [0.4.3]
* #49 add info --path option

## [0.4.2]
* #48 add logs pid option
* default to input false, encourage set tfvars

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
* remove redundant `terraspace tfc setup`, instead use: `terraspace tfc sync`
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
* TFC commands: terraspace tfc runs list, terraspace tfc runs prune
* TFC VCS also sync as part of deploy. Also separate `terraspace tfc sync` command
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
* New commands: terraspace list, terraspace tfc list, terraspace tfc setup, terraspace tfc destroy, terraspace new shim, terraspace new git_hook
* terraspace list: list of modules and stacks
* terraspace tfc list: shows list of TFC workspaces
* terraspace tfc setup: setups up TFC workspace for VCS-driven workflow. This automatically happens for the TFC CLI-driven workflow.
* terraspace tfc destroy: destroys the TFC workspace associated with the stack. Can also use the `terraspace down demo --destroy-workspace` option.
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
