#!/bin/bash

# Make tempfiles
temp="$(mktemp)"
log="$(mktemp)"

# Check target file, if symlink (eg. homeshick castle), follow it
target="$HOME/.tmux/tmuxline.conf"
if [ -L "$target" ]; then
    target="$(readlink -f "$target")"
fi

# Put the vim commands into the tempfile
cat >"$temp" <<EOF
redir! >$log

" tmuxline.vim needs to be enabled
if exists(":TmuxlineSnapshot")
    :Tmuxline airline

    " Overwrite the file even if it exists
    TmuxlineSnapshot! $target
else
    echo "Error: the plugin promptline.vim is not enabled."
endif

redir END
q
EOF

# Call vim in ex mode and memory only with the script
vim -e -n -S "$temp" 2>&1

# Display the output
cat "$log"

# Cleanup
rm "$temp" "$log"
