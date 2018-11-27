#!/usr/bin/env bash
set -xeuo pipefail
echo files: $@
[ "$1" = "./a" ] # is named a
