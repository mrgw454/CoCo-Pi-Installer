#!/bin/bash

base="CoCo-Pi-Installer-staging"
pattern="CoCo-Pi-Installer-staging-*"
file="mame-menus.tar.gz"

latest=$(ls -d $pattern 2>/dev/null | sort | tail -n 1)

if [ ! -f "$base/$file" ]; then
    echo "❌ Missing: $base/$file"
    exit 1
fi

if [ -z "$latest" ] || [ ! -f "$latest/$file" ]; then
    echo "❌ No backup archive found to compare against."
    exit 1
fi

tmp_new=$(mktemp -d -t new.XXXXXX)
tmp_old=$(mktemp -d -t old.XXXXXX)

tar -xzf "$base/$file" -C "$tmp_new"
tar -xzf "$latest/$file" -C "$tmp_old"

echo
echo "🔍 Comparing:"
echo "  NEW → $base/$file"
echo "  OLD → $latest/$file"
echo

diff -qr "$tmp_old" "$tmp_new" | awk -v old="$tmp_old" -v new="$tmp_new" '
/Only in / {
    path = $3;
    file = substr($0, index($0,$4));
    if (path == old || index(path, old "/") == 1) {
        print "🗑️ Missing from NEW: " file;
    } else if (path == new || index(path, new "/") == 1) {
        print "🆕 Present in NEW only: " file;
    }
}
'

rm -rf "$tmp_new" "$tmp_old"
