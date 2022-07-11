# Cody Files

The files in folder are used by cody to build AWS CodeBuild projects.  For more info, check out the [cody docs](https://cody.run). Here's a quick start.

## Install Tool

    gem install cody

This installs the `cody` command to manage the AWS CodeBuild project.

## Update Project

    cody up --type aws

## Start a Deploy

To start a CodeBuild build:

    cody start --type aws
    cody start --type azurerm
    cody start --type google
    cody start --type none
    cody start --type unit

To specify a branch:

    cody start --type aws -b feature
