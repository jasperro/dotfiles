#!/usr/bin/env bash
set -euo pipefail

# Set up cache path
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nix_wofi_launcher"
RECENT_FILE="$CACHE_DIR/recent"

mkdir -p "$CACHE_DIR"
touch "$RECENT_FILE"

MAX_RECENT=20 # Max number of recent entries

while true; do
    # Show recent items first
    RECENT_MENU=$(tac "$RECENT_FILE" 2>/dev/null | head -n "$MAX_RECENT")

    # Let user input query
    QUERY=$(printf "%s\n" "$RECENT_MENU" | wofi --dmenu --prompt "Search nixpkgs..." --cache-file /dev/null)

    # If empty or Esc pressed, exit
    if [ -z "$QUERY" ]; then
        exit 0
    fi

    # If user selected one of the cached recent items
    if grep -q "^$QUERY\$" "$RECENT_FILE"; then
        ID="$QUERY"
    else
        # Otherwise, treat it as a search term
        RESULTS=$(nix search nixpkgs "$QUERY" --json --extra-experimental-features nix-command 2>/dev/null)

        MENU=$(echo "$RESULTS" | jq -r '
          to_entries[] |
          {
            id: .key | split(".")[2],
            description: .value.description,
            version: .value.version
          } |
          "\(.id) (\(.version)) - \(.description)"
        ')

        if [ -z "$MENU" ]; then
            echo "No matches found" | wofi --dmenu --prompt "Nothing found" --cache-file /dev/null
            continue
        fi

        # Let user pick from search results
        SELECTED=$(echo "$MENU" | wofi --dmenu --prompt "Select package" --cache-file /dev/null)

        [ -z "$SELECTED" ] && continue

        ID=$(echo "$SELECTED" | awk '{print $1}')
    fi

    # Ask whether to Run or Shell
    ACTION=$(printf "Run\nShell" | wofi --dmenu --prompt "Run or Shell?" --cache-file /dev/null)

    [ -z "$ACTION" ] && continue

    # Save selected package to cache (remove duplicates first)
    grep -v "^$ID\$" "$RECENT_FILE" > "$RECENT_FILE.tmp" || true
    echo "$ID" >> "$RECENT_FILE.tmp"
    mv "$RECENT_FILE.tmp" "$RECENT_FILE"

    # Execute with kitty terminal
    if [ "$ACTION" = "Shell" ]; then
        kitty nix shell "nixpkgs#$ID" --extra-experimental-features nix-command &
    elif [ "$ACTION" = "Run" ]; then
        kitty nix run "nixpkgs#$ID" --extra-experimental-features nix-command &
    fi

    exit 0
done
