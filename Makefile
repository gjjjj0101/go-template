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

# If output setup environment file
ENV_FILE ?= y

#-----------------------------------------------------------------------------
# Default target
#-----------------------------------------------------------------------------

default: help

help: # @HELP (default) print this message
help:
	echo -e "${RED_COLOR}VARIABLES:${NO_COLOR}"
	echo -e " ${BLUE_COLOR} BINS ${NO_COLOR} = ${GREEN_COLOR} $(TARGET_BASE_NAME) ${NO_COLOR}"
	echo -e " ${BLUE_COLOR} OS ${NO_COLOR} = ${GREEN_COLOR} $(OS) ${NO_COLOR}"
	echo -e " ${BLUE_COLOR} ARCH ${NO_COLOR} = ${GREEN_COLOR} $(ARCH) ${NO_COLOR}"
	echo -e " ${BLUE_COLOR} DBG ${NO_COLOR} = ${GREEN_COLOR} $(DBG) ${NO_COLOR}"
	echo -e " ${BLUE_COLOR} GOFLAGS ${NO_COLOR} = ${GREEN_COLOR} $(GOFLAGS) ${NO_COLOR}"
	echo -e " ${BLUE_COLOR} REGISTRY ${NO_COLOR} = ${GREEN_COLOR} $(REGISTRY) ${NO_COLOR}"
	echo -e " ${BLUE_COLOR} VERSION ${NO_COLOR} = ${GREEN_COLOR} $(VERSION) ${NO_COLOR}"
	echo
	echo -e "${RED_COLOR}MAKE_TARGETS:${NO_COLOR}"
	grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST)    \
	    | sed -E 's/.*.mk://g'                   \
	    | awk '                                  \
	        BEGIN {FS = ": *# *@HELP"};          \
	        { printf " \033[36m%-15s\033[0m \033[0;32m%s\033[0m\n", $$1, $$2 };' \

#-----------------------------------------------------------------------------
# Include makefile
#-----------------------------------------------------------------------------

include make/common.mk
include make/golang.mk
include make/image.mk