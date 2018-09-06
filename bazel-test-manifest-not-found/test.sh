#!/usr/bin/env bash
set -e

# env | grep RUNFILES

echo "Manifest:"
f=$(printenv RUNFILES_MANIFEST_FILE)
cat $f
echo YAY
