#!/usr/bin/env bash

source "$PROJECT_ROOT/tests/setup.sh"
echo "FOO=bar" >.env

set +e
result=$(sh -c 'echo $FOO')
if [ "$result" != "" ]; then
  echo "Error: FOO must be empty"
  exit 1
fi

# shellcheck disable=SC2016
result=$(env-run sh -c 'echo $FOO')
if [ "$result" != "bar" ]; then
  echo "Error: FOO must be bar"
  exit 1
fi
set -e

source "$PROJECT_ROOT/tests/teardown.sh"
