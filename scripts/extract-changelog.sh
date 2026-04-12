#!/usr/bin/env bash
# Extract the changelog section for a given version tag from CHANGELOG.md.
# Usage: ./scripts/extract-changelog.sh <version>
# Example: ./scripts/extract-changelog.sh 0.6.4
set -euo pipefail

VERSION="${1:?Usage: $0 <version>}"
CHANGELOG="${2:-CHANGELOG.md}"

awk -v version="$VERSION" '
  /^## \[/ {
    if (in_section) exit
    if ($0 ~ "^## \\[" version "\\]") in_section = 1
    next
  }
  in_section { print }
' "$CHANGELOG"
