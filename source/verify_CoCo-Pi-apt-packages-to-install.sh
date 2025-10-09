#!/bin/bash

# Usage: ./verify_packages2.sh your_script.sh

SCRIPT="$1"
if [[ ! -f "$SCRIPT" ]]; then
  echo "Error: File '$SCRIPT' not found."
  exit 1
fi

echo "🔎 Parsing package list from '$SCRIPT'..."

# Extract package names from uncommented apt install lines
PACKAGES=$(grep -E '^\s*[^#]*\bapt(-get)?(\s+-[a-zA-Z0-9]+)*\s+install' "$SCRIPT" | \
           sed -E 's/#.*//' | \
           sed -E 's/.*apt(-get)?(\s+-[a-zA-Z0-9]+)*\s+install(\s+-[a-zA-Z0-9]+)* //' | \
           tr ' ' '\n' | \
           grep -vE '^[\-]' | \
           grep -v '^$' | \
           sort -u)

echo "📦 Found $(echo "$PACKAGES" | wc -l) packages to check."
echo

MISSING=()
INSTALLED=()

for pkg in $PACKAGES; do
  echo -n "🔍 Checking '$pkg'... "
  if dpkg -s "$pkg" &> /dev/null; then
    echo "✅ Installed"
    INSTALLED+=("$pkg")
  else
    echo "❌ Not installed"
    MISSING+=("$pkg")
  fi
done

echo
echo "📋 Summary:"
echo "✅ Installed: ${#INSTALLED[@]}"
echo "❌ Missing:   ${#MISSING[@]}"

if [[ ${#MISSING[@]} -gt 0 ]]; then
  echo -e "\nMissing packages:"
  for pkg in "${MISSING[@]}"; do
    echo "  - $pkg"
  done
  echo -e "\nTo install them, run:"
  echo "sudo apt install ${MISSING[*]}"
else
  echo -e "\n🎉 All packages are installed!"
fi
