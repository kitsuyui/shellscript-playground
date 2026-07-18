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

result=$(generate-web-icons 2>&1)
status=$?
if [ "$status" -eq 0 ]; then
  echo "Failed to reject missing input image"
  exit 1
fi
if [[ "$result" != *"Usage: generate-web-icons <image_file>"* ]]; then
  echo "Failed to show usage for missing input image"
  echo "$result"
  exit 1
fi

result=$(generate-web-icons --help 2>&1)
status=$?
if [ "$status" -ne 0 ]; then
  echo "Failed to show help"
  echo "$result"
  exit 1
fi
if [[ "$result" != *"Usage: generate-web-icons <image_file>"* ]]; then
  echo "Failed to show usage for help"
  echo "$result"
  exit 1
fi

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

result=$(GENERATE_WEB_ICONS_MAX_INPUT_BYTES=1 generate-web-icons "$icon_file" 2>&1)
status=$?
if [ "$status" -eq 0 ]; then
  echo "Failed to reject oversized file by byte limit"
  echo "$result"
  exit 1
fi
if [[ "$result" != *"input image is too large"* ]]; then
  echo "Failed to show oversized file limit message"
  echo "$result"
  exit 1
fi

result=$(GENERATE_WEB_ICONS_MAX_INPUT_DIMENSION=16 generate-web-icons "$icon_file" 2>&1)
status=$?
if [ "$status" -eq 0 ]; then
  echo "Failed to reject oversized image by dimension limit"
  echo "$result"
  exit 1
fi
if [[ "$result" != *"input image dimensions are too large"* ]]; then
  echo "Failed to show oversized dimension limit message"
  echo "$result"
  exit 1
fi

result=$(GENERATE_WEB_ICONS_MAX_INPUT_PIXELS=1 generate-web-icons "$icon_file" 2>&1)
status=$?
if [ "$status" -eq 0 ]; then
  echo "Failed to reject oversized image by pixel limit"
  echo "$result"
  exit 1
fi
if [[ "$result" != *"input image pixel count too large"* ]]; then
  echo "Failed to show oversized pixel limit message"
  echo "$result"
  exit 1
fi

set -e

rm -f "$tobe_tarball"

fake_bin="$WORK_DIR/fake-bin"
magick_calls="$WORK_DIR/magick-calls.log"
mkdir -p "$fake_bin"

cat >"$fake_bin/magick" <<'BASH'
#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' "$*" >>"$MAGICK_CALL_LOG"
if [ "$1" = "identify" ]; then
  printf '16 16\n'
  exit 0
fi
target_file="${@: -1}"
mkdir -p "$(dirname "$target_file")"
printf 'fake icon\n' >"$target_file"
BASH
chmod +x "$fake_bin/magick"

MAGICK_CALL_LOG="$magick_calls" PATH="$fake_bin:$PROJECT_ROOT/bin:/bin:/usr/bin" generate-web-icons "$icon_file"

if [ ! -f "$tobe_tarball" ]; then
  echo "Failed to generate web icons with magick command"
  echo "Tarball file not found: $tobe_tarball"
  exit 1
fi

if [ ! -s "$magick_calls" ]; then
  echo "Failed to use magick command"
  exit 1
fi
if ! grep -q '^identify ' "$magick_calls"; then
  echo "Failed to use magick identify fallback"
  cat "$magick_calls"
  exit 1
fi

assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon.ico"
assert_tar_contains_target_file "$tobe_tarball" "example-icon/favicon192.png"

rm -f "$tobe_tarball"

# Test: dotfile input with extension (e.g., ".hidden-icon.png")
# get_name_without_extension previously returned "" for dotfiles, producing ".tar.gz".
dotfile_icon="$WORK_DIR/.hidden-icon.png"
cp "$icon_file" "$dotfile_icon"
dotfile_tarball=".hidden-icon.tar.gz"

MAGICK_CALL_LOG="$magick_calls" PATH="$fake_bin:$PROJECT_ROOT/bin:/bin:/usr/bin" generate-web-icons "$dotfile_icon"

if [ ! -f "$dotfile_tarball" ]; then
  echo "Failed: dotfile input did not produce $dotfile_tarball"
  exit 1
fi

assert_tar_contains_target_file "$dotfile_tarball" ".hidden-icon/favicon.ico"
assert_tar_contains_target_file "$dotfile_tarball" ".hidden-icon/favicon192.png"
rm -f "$dotfile_tarball"

source "$PROJECT_ROOT/tests/teardown.sh"
