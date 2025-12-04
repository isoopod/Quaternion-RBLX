#!/bin/bash
set -e

# Usage: scripts/release.sh 0.1.0

if [ -z "$1" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

VERSION="$1"

# Update Wally version
sed -i "s/^version = .*/version = \"$VERSION\"/" wally.toml

# Update Pesde version
sed -i "s/^version = .*/version = \"$VERSION\"/" pesde.toml

# Commit version bumps
git add wally.toml pesde.toml
git commit -m "release: v$VERSION"
git push

# Publish
wally publish
pesde publish

rojo build -o build.rbxm

echo "Release $VERSION published. Create GitHub release manually from build.rbxm."