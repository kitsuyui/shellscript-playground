#!/usr/bin/env bash

set -euo pipefail

PROJECT_ROOT=$(git rev-parse --show-toplevel)
export PROJECT_ROOT

failed=0
# Run ./tests/test-*.sh
for test in tests/test-*.sh; do
    echo "Running $test"
    if ! "$test"; then
        echo "Error: $test failed"
        failed=1
    else
        echo "Success: $test"
    fi
done

if [ $failed -ne 0 ]; then
    echo "Some tests failed"
    exit 1
fi
