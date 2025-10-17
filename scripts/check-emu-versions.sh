#!/bin/bash

echo
echo

# Check for MAME
if command -v mame >/dev/null 2>&1; then
    echo "MAME version:"
    mame -version | head -n 1
else
    echo "MAME not found in PATH."
fi

echo ""

# Check for XRoar
if command -v xroar >/dev/null 2>&1; then
    echo "XRoar version:"
    xroar --version 2>&1 | grep -E '^XRoar ' || echo "Could not parse XRoar version."
else
    echo "XRoar not found in PATH."
fi

echo
echo

