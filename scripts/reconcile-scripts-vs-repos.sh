#!/bin/bash

SOURCE_DIR="$HOME/source"
MISSING_REPORT=()

for script in "$SOURCE_DIR"/make*.sh; do
    [ -f "$script" ] || continue

    expected_folders=()
    missing_folders=()

    while IFS= read -r line; do
        # Normalize line spacing
        line=$(echo "$line" | tr -s ' ')

        # Detect git/hg clone commands
        if [[ "$line" =~ ^[[:space:]]*(git|hg)[[:space:]]+clone ]]; then
            # Tokenize line
            tokens=()
            while read -r token; do
                tokens+=("$token")
            done < <(echo "$line" | awk '{for(i=1;i<=NF;i++) print $i}')

            # Find last non-flag token after 'clone'
            found_clone=false
            repo=""
            target=""
            for token in "${tokens[@]}"; do
                if $found_clone; then
                    if [[ "$token" == -* ]]; then
                        continue
                    elif [[ "$repo" == "" ]]; then
                        repo="$token"
                    else
                        target="$token"
                    fi
                elif [[ "$token" == "clone" ]]; then
                    found_clone=true
                fi
            done

            # Determine folder
            if [[ -n "$target" ]]; then
                [[ "$target" = /* ]] || target="$SOURCE_DIR/$target"
                expected_folders+=("$target")
            elif [[ -n "$repo" ]]; then
                # Infer folder name from repo URL
                repo_name=$(basename "$repo" .git)
                expected_folders+=("$SOURCE_DIR/$repo_name")
            fi
        fi

        # Detect md folder creation
        if [[ "$line" =~ md[[:space:]]+\"?([^\"]*${SOURCE_DIR//\//\\/}[^[:space:]\"]*)\"? ]]; then
            folder="${BASH_REMATCH[1]}"
            expected_folders+=("$folder")
        fi

        # Detect mkdir or install -d
        if [[ "$line" =~ (mkdir|install)[[:space:]]+-[[:space:]]*d[[:space:]]+\"?([^\"]*${SOURCE_DIR//\//\\/}[^[:space:]\"]*)\"? ]]; then
            folder="${BASH_REMATCH[2]}"
            expected_folders+=("$folder")
        fi
    done < "$script"

    # Check for missing folders
    for folder in "${expected_folders[@]}"; do
        [ -d "$folder" ] || missing_folders+=("$folder")
    done

    if [ "${#missing_folders[@]}" -gt 0 ]; then
        reason="Missing folder(s):"
        for f in "${missing_folders[@]}"; do
            reason+=" $(basename "$f"),"
        done
        reason="${reason%,}"  # Trim trailing comma
        MISSING_REPORT+=("$script - $reason")
    fi
done

# Output report
if [ "${#MISSING_REPORT[@]}" -eq 0 ]; then
    echo "✅ All make*.sh scripts appear to have been run successfully."
else
    echo "⚠️ Scripts that appear not to have been run:"
    for entry in "${MISSING_REPORT[@]}"; do
        echo "$entry"
    done
fi
