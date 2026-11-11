#!/usr/bin/env bash

set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MONITOR="$SCRIPT_DIR/health-check.sh"

tests_passed=0
tests_failed=0

run_test() {
    local name="$1"
    local expected="$2"
    local process="$3"
    local actual

    "$MONITOR" "$process" > /dev/null 2>&1
    actual=$?

    if (( actual == expected )); then
        echo "PASS: $name"
        ((tests_passed+=1))
    else
        echo "FAIL: $name (expected $expected, got $actual)"
        ((tests_failed+=1))
    fi
}

# Guaranteed-missing process name for this test
run_test "Missing process returns warning" 1 "no_such_proc_987"

echo
echo "Passed: $tests_passed"
echo "Failed: $tests_failed"

if (( tests_failed > 0 )); then
    exit 1
fi

exit 0
