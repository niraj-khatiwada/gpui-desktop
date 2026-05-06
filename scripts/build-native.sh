#!/usr/bin/env bash

set -euo pipefail

SRC_DIR="./native"
OUT_DIR="./dist/native"

mkdir -p "$OUT_DIR"

echo "Building Swift native tools..."

for file in "$SRC_DIR"/*.swift; do
  [ -e "$file" ] || continue

  filename=$(basename "$file")
  name="${filename%.swift}"

  output="$OUT_DIR/$name"

  echo "→ Compiling $filename → $output"

  swiftc -O \
    -o "$output" \
    "$file" \
    -framework AppKit
done