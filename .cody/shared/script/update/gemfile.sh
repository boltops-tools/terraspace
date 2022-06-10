#!/bin/bash
sed -i 's/gem "terraspace".*/gem "terraspace", path: ENV[\"CODEBUILD_SRC_DIR\"]/' Gemfile
