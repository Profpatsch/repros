#!/usr/bin/env bash
set -xeuo pipefail
echo files: $@
grep -e "a" "$1" # content is a
