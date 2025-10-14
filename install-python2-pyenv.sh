#!/bin/bash

# Target Python version for python2 support
PYTHON_VERSION="2.7.18"

# Check if pyenv is available
if ! command -v pyenv &> /dev/null; then
  echo "❌ pyenv is not installed or not in PATH."
  exit 1
fi

# Check if Python version is already installed
if pyenv versions --bare | grep -q "^${PYTHON_VERSION}$"; then
  echo "✅ Python ${PYTHON_VERSION} is already installed in pyenv."
else
  echo "🔧 Installing Python ${PYTHON_VERSION} via pyenv..."
  pyenv install "${PYTHON_VERSION}"
  echo "✅ Installation complete."
fi

echo
echo
echo Done!
echo
