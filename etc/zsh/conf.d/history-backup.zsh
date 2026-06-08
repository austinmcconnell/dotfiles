# Daily history backup with truncation guard.
# Keeps 60 days of date-stamped backups. Only writes a new backup
# if the current HISTFILE is at least as large as the most recent backup.

_backup_history() {
    emulate -L zsh

    [[ -s "$HISTFILE" ]] || return 0

    local backup_dir="${HISTFILE:h}/backups"
    local today_backup="$backup_dir/${HISTFILE:t}.$(date +%Y-%m-%d)"

    # Already backed up today
    [[ -f "$today_backup" ]] && return 0

    mkdir -p "$backup_dir" && chmod 700 "$backup_dir"

    # Size guard: refuse to back up a truncated file
    local current_size
    current_size=$(wc -c < "$HISTFILE")
    local latest_backup
    latest_backup=$(command ls -t "$backup_dir"/${HISTFILE:t}.*(N) 2>/dev/null | head -1)

    if [[ -n "$latest_backup" ]]; then
        local backup_size
        backup_size=$(wc -c < "$latest_backup")
        if (( current_size < backup_size )); then
            echo "⚠️  History appears truncated (${current_size}B vs ${backup_size}B backup). Skipping backup." >&2
            echo "   Restore with: cp $latest_backup $HISTFILE" >&2
            return 1
        fi
    fi

    cp "$HISTFILE" "$today_backup" || { rm -f "$today_backup"; return 1; }
    chmod 600 "$today_backup"

    # Prune backups older than 60 days
    find "$backup_dir" -name "${HISTFILE:t}.*" -mtime +60 -delete 2>/dev/null
}
_backup_history
unfunction _backup_history
