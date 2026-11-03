#!/usr/bin/env bash
set -euo pipefail

# Run from the folder containing this script.
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

echo "Welcome to the release build script!"

# Read the version from the first line of source/changelog.md.
if [[ ! -f source/changelog.md ]]; then
  echo "Error: source/changelog.md was not found." >&2
  exit 1
fi

firstline=$(head -n 1 source/changelog.md)
read -r -a splitfirstline <<< "$firstline"
version="${splitfirstline[1]:-}"

if [[ -z "$version" ]]; then
  echo "Error: expected a version on the first line (for example: ## 1.1.1)." >&2
  exit 1
fi

echo "You are building version $version."
read -r -p "Have you updated changelog.md? Enter 1 to continue or 0 to exit: " versioncontinue

if [[ "$versioncontinue" == "1" ]]; then
  echo "OK"
  mkdir -p build

  # Ensure that a secret copied during an older build cannot be released.
  rm -f -- build/secretinfo.md

  for filename in source/*; do
    [[ -f "$filename" ]] || continue
    echo "Found: $filename"

    if [[ "$filename" == "source/secretinfo.md" ]]; then
      echo "Not copying $filename (private information)."
    else
      echo "Copying $filename to build/"
      cp -- "$filename" build/
    fi
  done

  cd build
  echo "Files in build/ for version $version:"
  ls -1
  cd ..
else
  echo "Please come back when you are ready"
fi
