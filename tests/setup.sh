#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT=$(git rev-parse --show-toplevel)

# Clear all environment variables before tests
unset $(env | grep -v 'PROJECT_ROOT' | cut -d= -f1)
PATH='/bin/:/usr/bin'
PATH="$PATH:$PROJECT_ROOT/bin"
export PATH

# Create a temporary directory and return its path
WORK_DIR=$(mktemp -d)
cd "$WORK_DIR"
export WORK_DIR
export PROJECT_ROOT
