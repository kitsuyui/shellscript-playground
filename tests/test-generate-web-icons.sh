#!/usr/bin/env bash

PRESERVE_PATH="$PATH"
source "$PROJECT_ROOT/tests/setup.sh"

# Get example .png icon file
icon_file="$PROJECT_ROOT/assets/icons/example-icon.png"

assert_tar_contains_target_file() {
  target_tarball="$1"
  target_file="$2"
  if ! tar -ztf "$target_tarball" "$target_file" &>/dev/null; then
    echo "Failed to generate web icons"
    echo "Tarball file not found: $target_file"
    exit 1
  fi
}

set +e
export PATH="$PROJECT_ROOT/bin:$PRESERVE_PATH"
result=$(generate-web-icons "$icon_file")
status=$?
tobe_tarball="./example-icon.tar.gz"

if [ $status -ne 0 ]; then
  echo "Failed to generate web icons"
  echo "$result"
  exit 1
fi

if [ ! -f "$tobe_tarball" ]; then
  echo "Failed to generate web icons"
  echo "Tarball file not found: $tobe_tarball"
  exit 1
fi

assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon.ico"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon16.ico"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon32.ico"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon48.ico"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon64.ico"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/apple-touch-icon57.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/apple-touch-icon60.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/apple-touch-icon72.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/apple-touch-icon76.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/apple-touch-icon114.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/apple-touch-icon120.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/apple-touch-icon144.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/apple-touch-icon152.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/apple-touch-icon180.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon16.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon32.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon48.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon96.png"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon192.png"

set -e

source "$PROJECT_ROOT/tests/teardown.sh"
