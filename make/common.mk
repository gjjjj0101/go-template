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


# It's necessary to set this because some environments don't link sh -> bash.
SHELL := /usr/bin/env bash -o errexit -o pipefail -o nounset
$(shell $(shell pwd)/build/setup_env.sh ${ENV_FILE} > env/.setup.env)
include env/.setup.env

# Export the environment variables you provide 
-include env/.env

#-----------------------------------------------------------------------------
# Common Variables
#-----------------------------------------------------------------------------

# the variable priority: env/.env > common.mk
# If you don't like additional file, you can set common variables here without setting in .env file
TARGET_BASE_NAME ?= go-template
TARGET_OUT_PATH ?= bin
TARGET_VERSION ?= 0.0.1-alpha.0
TARGET_CMD ?= .


#-----------------------------------------------------------------------------
# Global Variables
#-----------------------------------------------------------------------------

GIT_VERSION := $(shell git describe --tags --always --dirty)

ifeq ($(TARGET_VERSION),)
VERSION := $(GIT_VERSION)
else
VERSION := $(TARGET_VERSION)
endif

OS := $(TARGET_OS)
ARCH := $(TARGET_ARCH)
BIN_FULLNAME := $(TARGET_BASE_NAME)-$(VERSION)-$(OS)-$(ARCH)

#-----------------------------------------------------------------------------
# Colors: global colors to share.
#-----------------------------------------------------------------------------

NO_COLOR := \033[0m
BOLD_COLOR := \n\033[1m
RED_COLOR := \033[0;31m
GREEN_COLOR := \033[0;32m
YELLOW_COLOR := \033[0;33m
BLUE_COLOR := \033[36m