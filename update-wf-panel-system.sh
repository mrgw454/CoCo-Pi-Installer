#!/bin/bash

CONFIG="/etc/xdg/wf-panel-pi/wf-panel-pi.ini"
TIME_FORMAT="%I:%M %p"
DATE_FORMAT="%A, %d %B %Y"

# Require root
if [[ $EUID -ne 0 ]]; then
  echo "❌ Please run as root: sudo $0"
  exit 1
fi

# Abort if config file doesn't exist
if [[ ! -f "$CONFIG" ]]; then
  echo "❌ Config file not found: $CONFIG"
  exit 1
fi

# Backup first
cp "$CONFIG" "$CONFIG.bak"
echo "📦 Backup saved to $CONFIG.bak"

# Update clock_time_format
if grep -q "^clock_time_format=" "$CONFIG"; then
  current=$(grep "^clock_time_format=" "$CONFIG" | cut -d= -f2-)
  if [[ "$current" != "$TIME_FORMAT" ]]; then
    sed -i "s|^clock_time_format=.*|clock_time_format=$TIME_FORMAT|" "$CONFIG"
    echo "🔧 Updated clock_time_format"
  else
    echo "✅ clock_time_format already correct"
  fi
else
  echo "clock_time_format=$TIME_FORMAT" >> "$CONFIG"
  echo "➕ Added clock_time_format"
fi

# Update clock_date_format
if grep -q "^clock_date_format=" "$CONFIG"; then
  current=$(grep "^clock_date_format=" "$CONFIG" | cut -d= -f2-)
  if [[ "$current" != "$DATE_FORMAT" ]]; then
    sed -i "s|^clock_date_format=.*|clock_date_format=$DATE_FORMAT|" "$CONFIG"
    echo "🔧 Updated clock_date_format"
  else
    echo "✅ clock_date_format already correct"
  fi
else
  echo "clock_date_format=$DATE_FORMAT" >> "$CONFIG"
  echo "➕ Added clock_date_format"
fi

# Ensure lxterminal is set in launchers=
if grep -q "^launchers=" "$CONFIG"; then
  line=$(grep "^launchers=" "$CONFIG")
  if echo "$line" | grep -Eq "xterm|x-terminal-emulator"; then
    updated=$(echo "$line" | sed -E 's/xterm|x-terminal-emulator/lxterminal/g')
    sed -i "s|^launchers=.*|$updated|" "$CONFIG"
    echo "🔧 Replaced terminal with lxterminal in launchers="
  elif ! echo "$line" | grep -q "lxterminal"; then
    updated="$line lxterminal"
    sed -i "s|^launchers=.*|$updated|" "$CONFIG"
    echo "➕ Appended lxterminal to launchers="
  else
    echo "✅ lxterminal already present in launchers="
  fi
else
  echo "launchers=lxterminal" >> "$CONFIG"
  echo "➕ Added launchers=lxterminal"
fi

echo "✅ System-wide wf-panel-pi config updated."
