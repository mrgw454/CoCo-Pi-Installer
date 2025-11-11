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

# Update or insert clock_time_format
if grep -q "^clock_time_format=" "$CONFIG"; then
  sed -i "s|^clock_time_format=.*|clock_time_format=$TIME_FORMAT|" "$CONFIG"
  echo "🔧 Updated clock_time_format"
else
  echo "clock_time_format=$TIME_FORMAT" >> "$CONFIG"
  echo "➕ Added clock_time_format"
fi

# Update or insert clock_date_format
if grep -q "^clock_date_format=" "$CONFIG"; then
  sed -i "s|^clock_date_format=.*|clock_date_format=$DATE_FORMAT|" "$CONFIG"
  echo "🔧 Updated clock_date_format"
else
  echo "clock_date_format=$DATE_FORMAT" >> "$CONFIG"
  echo "➕ Added clock_date_format"
fi

# Normalize launchers line
if grep -q "^launchers=" "$CONFIG"; then
  current=$(grep "^launchers=" "$CONFIG" | cut -d= -f2-)

  # Remove known terminal placeholders and duplicates
  cleaned=$(echo "$current" | sed -E 's/\b(xterm|x-terminal-emulator|llxterminalinal)\b//g' | tr -s ' ')
  
  # Ensure lxterminal is present
  if ! echo "$cleaned" | grep -qw "lxterminal"; then
    cleaned="$cleaned lxterminal"
  fi

  # Trim and update
  cleaned=$(echo "$cleaned" | sed 's/^ *//;s/ *$//')
  sed -i "s|^launchers=.*|launchers=$cleaned|" "$CONFIG"
  echo "🔧 Updated launchers= to: $cleaned"
else
  echo "launchers=lxterminal" >> "$CONFIG"
  echo "➕ Added launchers=lxterminal"
fi

# Kill panel to trigger reload
pkill wf-panel-pi && echo "🔁 Restarted wf-panel-pi"

echo "✅ System-wide wf-panel-pi config updated successfully."
