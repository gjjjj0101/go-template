#!/usr/bin/env bash

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

set -o errexit
set -o nounset
set -o pipefail

VARS=(
      TARGET_OS
      TARGET_ARCH
)

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
LOCAL_ARCH=$(uname -m)
TARGET_ARCH=
TARGET_OS=

# Pass environment set target architecture to build system
if [[ ${TARGET_ARCH} ]]; then
    # Target explicitly set
    :
elif [[ ${LOCAL_ARCH} == x86_64 ]]; then
    TARGET_ARCH=amd64
elif [[ ${LOCAL_ARCH} == armv8* ]]; then
    TARGET_ARCH=arm64
elif [[ ${LOCAL_ARCH} == arm64* ]]; then
    TARGET_ARCH=arm64
elif [[ ${LOCAL_ARCH} == aarch64* ]]; then
    TARGET_ARCH=arm64
elif [[ ${LOCAL_ARCH} == armv* ]]; then
    TARGET_ARCH=arm
elif [[ ${LOCAL_ARCH} == s390x ]]; then
    TARGET_ARCH=s390x
elif [[ ${LOCAL_ARCH} == ppc64le ]]; then
    TARGET_ARCH=ppc64le
else
    echo "This system's architecture, ${LOCAL_ARCH}, isn't supported"
    exit 1
fi

LOCAL_OS=$(uname)

# Pass environment set target operating-system to build system
if [[ ${TARGET_OS} ]]; then
    # Target explicitly set
    :
elif [[ $LOCAL_OS == Linux ]]; then
    TARGET_OS=linux
elif [[ $LOCAL_OS == Darwin ]]; then
    TARGET_OS=darwin
else
    echo "This system's OS, $LOCAL_OS, isn't supported"
    exit 1
fi
export x=1

if [[ "${1}" == "y" ]]; then
  for var in "${VARS[@]}"; do
    echo "${var}"="${!var}"
  done
else
  for var in "${VARS[@]}"; do
    export "${var}"
  done
fi