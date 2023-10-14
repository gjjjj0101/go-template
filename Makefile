# Copyright 2023 Gao Jian
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# If enable debug mode
DBG ?=
ifeq ($(DBG),1)
    $(warning ***** starting Makefile for goal(s) "$(MAKECMDGOALS)")
    $(warning ***** $(shell date))
else
    # If we're not debugging the Makefile, don't echo recipes.
    MAKEFLAGS += -s
	# If we're not debugging the Makefile, don't output environment variables to the file
endif

# Go version used as the image of the build container, grabbed from go.mod
GO_VERSION       := $(shell grep -E '^go [[:digit:]]{1,3}\.[[:digit:]]{1,3}$$' go.mod | sed 's/go //')
# Local Go release version (only supports go1.16 and later)
LOCAL_GO_VERSION := $(shell go env GOVERSION 2>/dev/null | grep -oE "go[[:digit:]]{1,3}\.[[:digit:]]{1,3}" || echo "none")

# Warn if local go release version is different from what is specified in go.mod.
ifneq (none, $(LOCAL_GO_VERSION))
  ifneq (go$(GO_VERSION), $(LOCAL_GO_VERSION))
    $(warning Your local Go release ($(LOCAL_GO_VERSION)) is different from the one that this go module assumes (go$(GO_VERSION)).)
  endif
endif

# It's necessary to set this because some environments don't link sh -> bash.
SHELL := /usr/bin/env bash -o errexit -o pipefail -o nounset

# If use setup environment file
ENV_FILE ?= y
$(shell $(shell pwd)/build/setup_env.sh ${ENV_FILE} > build/.setup.env)
include build/.setup.env

# Export the environment variables you provide 
-include ./build/.env

include Makefile.core.mk