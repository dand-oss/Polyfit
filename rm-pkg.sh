#!/usr/bin/env bash

# fail on error
set -eo pipefail

# get the repo name from the directory basename where the script is located
declare -r pkg="$(basename "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"

# delete
rm -rvf ${ASV_AF_PORTS}/build/${pkg}-build-${aplatform} ${ASV_PLAT_PORTS}/${pkg}
