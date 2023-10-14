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


#-----------------------------------------------------------------------------
# Global Variables
#-----------------------------------------------------------------------------

ifeq ($(TARGET_VERSION),)
VERSION := $(shell git describe --tags --always --dirty)
else
VERSION := $(TARGET_VERSION)
endif

OS := $(TARGET_OS)
ARCH := $(TARGET_ARCH)
BIN_FULLNAME := $(TARGET_BASE_NAME)-$(VERSION)-$(OS)-$(ARCH)



default: help

clean: # @HELP removes built binaries and temporary files
clean: 

help: # @HELP print this message
help: 
	echo "VARIABLES:"
	echo "  BINS = $(BINS)"
	echo "  OS = $(OS)"
	echo "  ARCH = $(ARCH)"
	echo "  DBG = $(DBG)"
	echo "  GOFLAGS = $(GOFLAGS)"
	echo "  REGISTRY = $(REGISTRY)"
	echo "  VERSION = $(VERSION)"
	echo
	echo "MAKE_TARGETS:"
	grep -E '^.*: *# *@HELP' $(MAKEFILE_LIST)    \
	    | sed -E 's_.*.mk:__g'                   \
	    | awk '                                  \
	        BEGIN {FS = ": *# *@HELP"};          \
	        { printf "  %-23s %s\n", $$1, $$2 }; \
	    '