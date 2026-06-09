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

result=$(env-run 2>&1)
status=$?
if [ "$status" -eq 0 ]; then
  echo "Error: env-run must fail without a command"
  exit 1
fi
if [[ "$result" != *"Usage: env-run <command> [args...]"* ]]; then
  echo "Error: env-run must show usage without a command"
  echo "$result"
  exit 1
fi

result=$(env-run --help 2>&1)
status=$?
if [ "$status" -ne 0 ]; then
  echo "Error: env-run --help must succeed"
  echo "$result"
  exit 1
fi
if [[ "$result" != *"Usage: env-run <command> [args...]"* ]]; then
  echo "Error: env-run --help must show usage"
  echo "$result"
  exit 1
fi
set -e

source "$PROJECT_ROOT/tests/teardown.sh"
