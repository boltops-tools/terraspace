# Pipedream Files

The files in folder are used by pipedream to build AWS CodePipeline pipelines.  For more info, check out the [pipedream docs](https://pipedream.run). Here's a quick start.

## Install Tool

    gem install pipedream

This installs both the `pipe` and `pipedream` commands. They do the same thing, the `pipe` command is just shorter to type.

## Update Project

To update the CodePipeline pipelines:

    pipedream deploy

## Start a Execution

To start a CodePipeline execution:

    pipedream start

To specify a branch:

    pipedream start -b feature
