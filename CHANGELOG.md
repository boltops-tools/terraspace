# Change Log

All notable changes to this project will be documented in this file.
This project *loosely tries* to adhere to [Semantic Versioning](http://semver.org/), even before v1.0.

## [2.1.5] - 2022-07-21
- [#255](https://github.com/boltops-tools/terraspace/pull/255) dont compute git info when not cloud not enabled and warn message improvement
- pin terraspace to major version in initially generated Gemfile

## [2.1.4] - 2022-07-16
- [#252](https://github.com/boltops-tools/terraspace/pull/252) puts friendlier user message with terraspace force_unlock suggestion
- [#253](https://github.com/boltops-tools/terraspace/pull/253) azure repo local git support

## [2.1.3] - 2022-07-13
- [#251](https://github.com/boltops-tools/terraspace/pull/251) deprecation warning for `:CACHE_ROOT` in `config.build.cache_dir`

## [2.1.2] - 2022-07-13
- [#249](https://github.com/boltops-tools/terraspace/pull/249) fix cost.enabled setting when nil

## [2.1.1] - 2022-07-12
- [#248](https://github.com/boltops-tools/terraspace/pull/248) fix destroy success return

## [2.1.0] - 2022-07-11
- [#247](https://github.com/boltops-tools/terraspace/pull/247) cost estimates and real-time stream logging
- Cloud Cost Estimation support
- Live Stream Logging support
- CI/CD plugin updates. Decoupled CI from PR plugins
- Improve git info. Get git info with or without CI
- Fix utf8 encoding edge cases

## [2.0.3] - 2022-07-04
- [#237](https://github.com/boltops-tools/terraspace/pull/237) remove duplicate paths in layering
- [#244](https://github.com/boltops-tools/terraspace/pull/244) rename _cache2 to .cache2
- [#245](https://github.com/boltops-tools/terraspace/pull/245) set utf8 in case system is not configured with LANG=en_US.UTF-8

## [2.0.2] - 2022-06-21
- [#242](https://github.com/boltops-tools/terraspace/pull/242) :PROJECT variable: TS_PROJECT as well as config.cloud.project

## [2.0.1] - 2022-06-14
- [#240](https://github.com/boltops-tools/terraspace/pull/240) add project expander variable

## [2.0.0] - 2022-06-10
* Terraspace Cloud Support

Highlights:
* Record updates to Terraspace Cloud API
* CI plugin support
* CI plugin generator
* VCS manual support in core for github, gitlab, bitbucket
* Layering: simplified by removing provider layering by default.
* Layering: new default  `config.layering.mode = "simple"`. Use `config.layering.mode = "provider"` for v1 behavior.
* Layering: easier to debug with config.layering.show
* Layering: App, Role, Extra level layering

More:
* Backend expander variables handle env vars in general
* Remove config.build.cache_root option
* cloud.record = "changes". dont create cloud record when no changes
* cloud warning message when TS_TOKEN is confiugred but cloud is not yet
* Cloud API expodential retry logic
* TS_EXTRA in favor of instance option, deprecate instance option
* handle ctrl-c
* improve acceptance codebuild scripts

## [1.1.7] - 2022-02-22
- [#215](https://github.com/boltops-tools/terraspace/pull/215) fix all down by building child nodes
- [#216](https://github.com/boltops-tools/terraspace/pull/216) add codebuild project with acceptance test for terraspace all

## [1.1.6] - 2022-02-21
- [#213](https://github.com/boltops-tools/terraspace/pull/213) ability to show layers for debugging

## [1.1.5] - 2022-02-21
- [#212](https://github.com/boltops-tools/terraspace/pull/212) ability to show layers for debugging
- show layers for debugging with logger level debug and TS_SHOW_ALL_LAYERS=1
- stringify_keys layer friendly names map

## [1.1.4] - 2022-02-21
- [#210](https://github.com/boltops-tools/terraspace/pull/210) write files without magic conversion, fixes #209
- cleanup argv and root
- write files without magic conversion, fixes #209

## [1.1.3] - 2022-02-17
- [#207](https://github.com/boltops-tools/terraspace/pull/207) dont fork when all.concurrency = 1

## [1.1.2] - 2022-02-17
- [#200](https://github.com/boltops-tools/terraspace/pull/200) fix terraspace typos
- [#202](https://github.com/boltops-tools/terraspace/pull/202) Windows support: fix include_dir for windows
- [#203](https://github.com/boltops-tools/terraspace/pull/203) Fix ERB for windows
- [#204](https://github.com/boltops-tools/terraspace/pull/204) improve file check
- setup check terraform_bin windows support
- slight layering improvement strip trailing slash, helps with custom layering

## [1.1.1] - 2022-02-02
- [#199](https://github.com/boltops-tools/terraspace/pull/199) build required dependent stacks as part of terraspace up

## [1.1.0] - 2022-01-30
- [#196](https://github.com/boltops-tools/terraspace/pull/196) terraspace all: build modules in batches and only each specific stack
- [#197](https://github.com/boltops-tools/terraspace/pull/197) all plan --output and all up --plan options
- simplify starter config/app.rb

## [1.0.6] - 2022-01-24
- [#195](https://github.com/boltops-tools/terraspace/pull/195) improve autodetection for plugin expander for backend like remote

## [1.0.5] - 2022-01-23
- [#194](https://github.com/boltops-tools/terraspace/pull/194) ability to allow and deny envs, regions, and stacks

## [1.0.4] - 2022-01-21
- [#193](https://github.com/boltops-tools/terraspace/pull/193) improve all include_stacks and exclude_stacks option

## [1.0.3] - 2022-01-20
- [#192](https://github.com/boltops-tools/terraspace/pull/192) run super-early boot hooks before dotenv load

## [1.0.2] - 2022-01-17
- [#190](https://github.com/boltops-tools/terraspace/pull/190) update terraspace-bundler gem depedency to 0.5.0

## [1.0.1] - 2022-01-15
- [#189](https://github.com/boltops-tools/terraspace/pull/189) dotenv support

## [1.0.0] - 2022-01-08
Highlights:
- Non-cloud provider support
- Better passthrough terraspace options to terraform. Pretty much all terraform options are now supported.
- Remove `terraspace_plugin_*` gem dependencies out of core
- Improve top CLI help: group main commands at top

Details:
- [#168](https://github.com/boltops-tools/terraspace/pull/168) terraspace new example command
- [#169](https://github.com/boltops-tools/terraspace/pull/169) fix new plugin generator, use right include Helper
- [#170](https://github.com/boltops-tools/terraspace/pull/170) remove project --test-structure option in favor of terraspace new test --type project
- [#171](https://github.com/boltops-tools/terraspace/pull/171) improve cli help: group main commands at top
- [#172](https://github.com/boltops-tools/terraspace/pull/172) better wrap and pass through terraform args
- [#173](https://github.com/boltops-tools/terraspace/pull/173) remove `terraspace_plugin_*` gem dependencies out of core
- [#174](https://github.com/boltops-tools/terraspace/pull/174) support non-cloud providers and backends
- [#175](https://github.com/boltops-tools/terraspace/pull/175) Pass args cleanup
- [#176](https://github.com/boltops-tools/terraspace/pull/176) fix new example command
- [#177](https://github.com/boltops-tools/terraspace/pull/177) Shim message
- [#178](https://github.com/boltops-tools/terraspace/pull/178) fix no backend.tf src file case
- [#179](https://github.com/boltops-tools/terraspace/pull/179) terraspace check setup command
- [#180](https://github.com/boltops-tools/terraspace/pull/180) hide check_setup command
- [#181](https://github.com/boltops-tools/terraspace/pull/181) generator improvements: core examples for plugin=none. creates simple random_pet
- [#182](https://github.com/boltops-tools/terraspace/pull/182) move backend auto creation to runner stage
- [#183](https://github.com/boltops-tools/terraspace/pull/183) fix example generator lang option
- allow --version command to run outside terraspace project
- allow terraspace -help to work also
- friendly shim message for gem dependency resolution errors
- Pretty much release 0.7.x

## [0.7.2] - 2022-01-05
- [#187](https://github.com/boltops-tools/terraspace/pull/187) put thor cli options at the end

## [0.7.1] - 2022-01-04
- [#185](https://github.com/boltops-tools/terraspace/pull/185) pass value through untouch when expand method not defined

## [0.7.0] - 2021-12-30
Highlights:
- Non-cloud provider support
- Better passthrough terraspace options to terraform. Pretty much all terraform options are now supported.
- Remove `terraspace_plugin_*` gem dependencies out of core
- Improve top CLI help: group main commands at top

Details:
- [#168](https://github.com/boltops-tools/terraspace/pull/168) terraspace new example command
- [#169](https://github.com/boltops-tools/terraspace/pull/169) fix new plugin generator, use right include Helper
- [#170](https://github.com/boltops-tools/terraspace/pull/170) remove project --test-structure option in favor of terraspace new test --type project
- [#171](https://github.com/boltops-tools/terraspace/pull/171) improve cli help: group main commands at top
- [#172](https://github.com/boltops-tools/terraspace/pull/172) better wrap and pass through terraform args
- [#173](https://github.com/boltops-tools/terraspace/pull/173) remove `terraspace_plugin_*` gem dependencies out of core
- [#174](https://github.com/boltops-tools/terraspace/pull/174) support non-cloud providers and backends
- [#175](https://github.com/boltops-tools/terraspace/pull/175) Pass args cleanup
- [#176](https://github.com/boltops-tools/terraspace/pull/176) fix new example command
- [#177](https://github.com/boltops-tools/terraspace/pull/177) Shim message
- [#178](https://github.com/boltops-tools/terraspace/pull/178) fix no backend.tf src file case
- [#179](https://github.com/boltops-tools/terraspace/pull/179) terraspace check setup command
- [#180](https://github.com/boltops-tools/terraspace/pull/180) hide check_setup command
- [#181](https://github.com/boltops-tools/terraspace/pull/181) generator improvements: core examples for plugin=none. creates simple random_pet
- [#182](https://github.com/boltops-tools/terraspace/pull/182) move backend auto creation to runner stage
- [#183](https://github.com/boltops-tools/terraspace/pull/183) fix example generator lang option
- allow --version command to run outside terraspace project
- allow terraspace -help to work also
- friendly shim message for gem dependency resolution errors

## [0.6.23] - 2021-12-18
- [#167](https://github.com/boltops-tools/terraspace/pull/167) require active_support properly

## [0.6.22] - 2021-12-16
- [#165](https://github.com/boltops-tools/terraspace/pull/165) check if file command is installed
- [#166](https://github.com/boltops-tools/terraspace/pull/166) add bundler as a dependency

## [0.6.21] - 2021-12-16
- [#164](https://github.com/boltops-tools/terraspace/pull/164) Use Activesupport All

## [0.6.20] - 2021-12-14
- [#162](https://github.com/boltops-tools/terraspace/pull/162) expand_string? interface method so plugins can decide whether or not to expand the string
- improve seed generator column spacing

## [0.6.19] - 2021-11-24
- [#149](https://github.com/boltops-tools/terraspace/pull/149) change default fallback mod strategy to Mod::Tf instead of Mod::Pass for ERB support
- [#152](https://github.com/boltops-tools/terraspace/pull/152) fix naming typo in cli help
- [#153](https://github.com/boltops-tools/terraspace/pull/153) only remove and create log dir if it exists
- [#155](https://github.com/boltops-tools/terraspace/pull/155) add terraspace bundle example cli help
- [#157](https://github.com/boltops-tools/terraspace/pull/157) handle edge case: Enter a value chopped off
- [#158](https://github.com/boltops-tools/terraspace/pull/158) use pass strategy for binary files
- [#159](https://github.com/boltops-tools/terraspace/pull/159) process terraform.tfvars file with erb, change default processing strategy back to pass

## [0.6.18] - 2021-10-28
- [#147](https://github.com/boltops-tools/terraspace/pull/147) improve error message output
- [#148](https://github.com/boltops-tools/terraspace/pull/148) Improve shim wrapper generator

## [0.6.17] - 2021-10-02
- [#142](https://github.com/boltops-tools/terraspace/pull/142) improve builder skip check: check if its a dir

## [0.6.16] - 2021-10-01
- [#141](https://github.com/boltops-tools/terraspace/pull/141) terraspace output: remove extra newline at the end

## [0.6.15] - 2021-10-01
- [#140](https://github.com/boltops-tools/terraspace/pull/140) fix terraspace output and Enter a value handling

## [0.6.14] - 2021-09-30
- [#134](https://github.com/boltops-tools/terraspace/pull/134) Use file not plan for the var-files argument
- [#139](https://github.com/boltops-tools/terraspace/pull/139) Fix terraspace output to not add extra newlines
- terraspace list: change default to show both stacks and modules

## [0.6.13] - 2021-08-10
- use terraspace-bundler 0.4.0

## [0.6.12] - 2021-07-26
- [#128](https://github.com/boltops-tools/terraspace/pull/128) Improve terraspace state comands and Terraspace.argv for internal usage
- [#129](https://github.com/boltops-tools/terraspace/pull/129) use Dir.glob(expr, File::FNM_DOTMATCH) so dotfiles are copied, allowing .terraform-version for tfenv
- allow -h to help outside terraspace project generally
- require rspec-terraspace 0.3.0
- state subcommands: straight delegate args
- Terraspace.argv for consistency with terraspace test

## [0.6.11] - 2021-06-22
- [#120](https://github.com/boltops-tools/terraspace/pull/120) version check handles a major change

## [0.6.10] - 2021-06-01
- [#117](https://github.com/boltops-tools/terraspace/pull/117) fix terraspace fmt -t all
- clean up IO select call

## [0.6.9] - 2021-05-07
- [#112](https://github.com/boltops-tools/terraspace/pull/112) fix smart auto retry

## [0.6.8] - 2021-05-07
- [#110](https://github.com/boltops-tools/terraspace/pull/110) fix popen deadlock with large amounts of output [#97](https://github.com/boltops-tools/terraspace/pull/97) Terraspace hangs when TF_LOG=TRACE environment variable exists #97

## [0.6.7] - 2021-05-05
- [#108](https://github.com/boltops-tools/terraspace/pull/108) provide runner context to terraspace hook

## [0.6.6] - 2021-04-15
- [#101](https://github.com/boltops-tools/terraspace/pull/101) terraspace force-unlock command
- [#102](https://github.com/boltops-tools/terraspace/pull/102) fix terraspace all summarized logging
- [#103](https://github.com/boltops-tools/terraspace/pull/103) config.build.pass_files with default files use pass strategy

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
