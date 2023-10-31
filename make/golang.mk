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
# Go Variables
#-----------------------------------------------------------------------------

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

VERSION_PACKAGE := main
GO_LDFLAGS += -X $(VERSION_PACKAGE).GitVersion=$(GIT_VERSION)\
              -X $(VERSION_PACKAGE).BuildDate=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ') \

#-----------------------------------------------------------------------------
# GO TARGET
#-----------------------------------------------------------------------------

.PHONY: init
init:
	mkdir -p "$(TARGET_OUT_PATH)"

.PHONY: build
build: # @HELP build binary for current platform
build: init $(addprefix build-, $(addprefix $(OS)_, $(ARCH)))


.PHONY: clean
clean: # @HELP clean all generated file
clean:

.PHONY: lint
lint: # @HELP Run go syntax and styling of go sources.
lint: 

.PHONY: format
format: # @HELP Format codes style with gofmt and goimports.
format:

.PHONY: test
test: # @HELP Run golang unit test in target paths.
test:

#-----------------------------------------------------------------------------
# INTERNAL TARGET
#-----------------------------------------------------------------------------

.PHONY: build-%
build-%: 
	$(eval OS := $(word 1, $(subst _, ,$*)))
	$(eval ARCH := $(word 2, $(subst _, ,$*)))
	echo "=======> Build binary $(TARGET_BASE_NAME)-$(VERSION)-$(OS)-$(ARCH)"
	@CGO_ENABLED=0 go build -o $(TARGET_OUT_PATH)/$(TARGET_BASE_NAME)-$(VERSION)-$(OS)-$(ARCH) -ldflags "$(GO_LDFLAGS)" $(TARGET_CMD)



