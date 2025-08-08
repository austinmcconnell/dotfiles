#!/usr/bin/env bash

# Script to analyze Git repositories and recommend maintenance
# Usage: ./analyze-git-repos.sh [directory]

SCAN_DIR="${1:-$HOME/projects}"
MAINTENANCE_THRESHOLD_MB=50
MAINTENANCE_THRESHOLD_OBJECTS=1000
ACTIVITY_THRESHOLD_DAYS=90 # Skip maintenance for repos inactive longer than this

echo "Scanning Git repositories in: $SCAN_DIR"
echo "========================================"
echo

# Temporary file for collecting summary data
TEMP_SUMMARY=$(mktemp)
TEMP_DISABLE_SUMMARY=$(mktemp)
trap 'rm -f "$TEMP_SUMMARY" "$TEMP_DISABLE_SUMMARY"' EXIT

# Function to safely convert to integer, defaulting to 0 if empty
safe_int() {
    local value="$1"
    if [[ -z "$value" || ! "$value" =~ ^[0-9]+$ ]]; then
        echo "0"
    else
        echo "$value"
    fi
}

# Function to get organization/repo format from path
get_org_repo_path() {
    local full_path="$1"
    local scan_dir="$2"
    local relative_path="${full_path#"$scan_dir"/}"

    # If the relative path has at least one slash, show org/repo format
    if [[ "$relative_path" == */* ]]; then
        echo "$relative_path"
    else
        # If no organization structure, just show the repo name
        echo "$relative_path"
    fi
}

# Function to get last activity date for a repository
get_last_activity() {
    local repo_dir="$1"
    local latest_timestamp=0
    local activity_type=""

    # Check last commit date
    if last_commit=$(git log -1 --format="%ct" 2>/dev/null) && [ -n "$last_commit" ]; then
        if [ "$last_commit" -gt "$latest_timestamp" ]; then
            latest_timestamp="$last_commit"
            activity_type="commit"
        fi
    fi

    # Check last fetch time (FETCH_HEAD file modification time)
    # Only consider if it's more recent than the last commit (indicates active pulling)
    if [ -f ".git/FETCH_HEAD" ]; then
        if fetch_time=$(stat -f "%m" ".git/FETCH_HEAD" 2>/dev/null); then
            # Only use fetch time if it's significantly newer than last commit
            # This helps avoid maintenance-related fetches
            if [ "$fetch_time" -gt "$((latest_timestamp + 3600))" ]; then
                latest_timestamp="$fetch_time"
                activity_type="fetch"
            fi
        fi
    fi

    # Check last checkout/branch switch (HEAD file modification time)
    # Only consider if significantly newer than last commit
    if [ -f ".git/HEAD" ]; then
        if head_time=$(stat -f "%m" ".git/HEAD" 2>/dev/null); then
            # Only consider HEAD changes that are newer than the last commit
            if [ "$head_time" -gt "$((latest_timestamp + 300))" ]; then
                latest_timestamp="$head_time"
                activity_type="checkout"
            fi
        fi
    fi

    # Check index file modification (staging area activity)
    if [ -f ".git/index" ]; then
        if index_time=$(stat -f "%m" ".git/index" 2>/dev/null); then
            if [ "$index_time" -gt "$latest_timestamp" ]; then
                latest_timestamp="$index_time"
                activity_type="staging"
            fi
        fi
    fi

    # Check for recent manual ref updates (branch/tag creation)
    # Skip maintenance-related refs like commit-graph, packed-refs
    if [ -d ".git/refs/heads" ]; then
        if refs_time=$(find ".git/refs/heads" -type f -exec stat -f "%m" {} \; 2>/dev/null | grep -E '^[0-9]+$' | sort -nr | head -1); then
            if [ -n "$refs_time" ] && [ "$refs_time" -gt "$latest_timestamp" ]; then
                latest_timestamp="$refs_time"
                activity_type="branch"
            fi
        fi
    fi

    if [ "$latest_timestamp" -gt 0 ]; then
        # Convert timestamp to human-readable format and calculate days ago
        if command -v gdate >/dev/null 2>&1; then
            # Use GNU date if available (from coreutils)
            activity_date=$(gdate -d "@$latest_timestamp" "+%Y-%m-%d")
            days_ago=$((($(gdate +%s) - latest_timestamp) / 86400))
        else
            # Use BSD date (macOS default)
            activity_date=$(date -r "$latest_timestamp" "+%Y-%m-%d")
            days_ago=$((($(date +%s) - latest_timestamp) / 86400))
        fi

        echo "$days_ago|$activity_date|$activity_type"
    else
        echo "999999|unknown|none"
    fi
}

# Find all .git directories
find "$SCAN_DIR" -name ".git" -type d | while read -r git_dir; do
    repo_dir=$(dirname "$git_dir")
    repo_name=$(basename "$repo_dir")

    echo "Repository: $repo_name"
    echo "Path: $repo_dir"

    # Change to repository directory
    cd "$repo_dir" || continue

    # Get repository statistics
    if ! stats=$(git count-objects -vH 2>/dev/null); then
        echo "  ❌ Error reading repository stats"
        echo
        continue
    fi

    # Parse statistics with safe defaults
    count=$(safe_int "$(echo "$stats" | grep "^count " | awk '{print $2}')")
    size=$(safe_int "$(echo "$stats" | grep "^size " | awk '{print $2}')")
    in_pack=$(safe_int "$(echo "$stats" | grep "^in-pack " | awk '{print $2}')")
    packs=$(safe_int "$(echo "$stats" | grep "^packs " | awk '{print $2}')")
    size_pack=$(safe_int "$(echo "$stats" | grep "^size-pack " | awk '{print $2}')")
    prune_packable=$(safe_int "$(echo "$stats" | grep "^prune-packable " | awk '{print $2}')")
    garbage=$(safe_int "$(echo "$stats" | grep "^garbage " | awk '{print $2}')")
    size_garbage=$(safe_int "$(echo "$stats" | grep "^size-garbage " | awk '{print $2}')")

    # Calculate total size in MB
    total_size_kb=$((size + size_pack + size_garbage))
    total_size_mb=$((total_size_kb / 1024))

    # Get commit count
    commit_count=$(git rev-list --all --count 2>/dev/null || echo "0")
    commit_count=$(safe_int "$commit_count")

    # Get branch count
    branch_count=$(git branch -a 2>/dev/null | wc -l | tr -d ' ')
    branch_count=$(safe_int "$branch_count")

    # Get last activity information
    activity_info=$(get_last_activity "$repo_dir")
    IFS='|' read -r days_ago activity_date activity_type <<<"$activity_info"

    echo "  📊 Statistics:"
    echo "    Loose objects: $count"
    echo "    Packed objects: $in_pack"
    echo "    Packs: $packs"
    echo "    Total size: ${total_size_mb}MB"
    echo "    Commits: $commit_count"
    echo "    Branches: $branch_count"
    echo "    Last activity: $activity_date ($days_ago days ago, $activity_type)"

    if [ "$prune_packable" -gt 0 ]; then
        echo "    Prune-packable: $prune_packable objects"
    fi

    if [ "$garbage" -gt 0 ]; then
        echo "    Garbage: $garbage objects (${size_garbage}KB)"
    fi

    # Check if maintenance is already enabled for this repository
    maintenance_enabled=false
    if git config --global --get-regexp "maintenance\.repo" | grep -q "^maintenance\.repo $repo_dir$"; then
        maintenance_enabled=true
        echo "  ✅ Maintenance: Already enabled"
    else
        echo "  ⚪ Maintenance: Not enabled"
    fi

    # Recommendation logic
    recommend_maintenance=false
    reasons=()

    # First, determine if maintenance should be recommended based on repo characteristics
    if [ "$total_size_mb" -gt "$MAINTENANCE_THRESHOLD_MB" ]; then
        recommend_maintenance=true
        reasons+=("Large repository size (${total_size_mb}MB)")
    fi

    if [ "$count" -gt "$MAINTENANCE_THRESHOLD_OBJECTS" ]; then
        recommend_maintenance=true
        reasons+=("Many loose objects ($count)")
    fi

    if [ "$commit_count" -gt 1000 ]; then
        recommend_maintenance=true
        reasons+=("Long history ($commit_count commits)")
    fi

    if [ "$prune_packable" -gt 100 ]; then
        recommend_maintenance=true
        reasons+=("Many prune-packable objects ($prune_packable)")
    fi

    if [ "$garbage" -gt 0 ]; then
        recommend_maintenance=true
        reasons+=("Garbage objects present ($garbage)")
    fi

    # Now apply activity-based logic and maintenance status
    if [ "$days_ago" -gt "$ACTIVITY_THRESHOLD_DAYS" ]; then
        if [ "$maintenance_enabled" = true ]; then
            echo "  🔄 RECOMMENDATION: Consider disabling maintenance (inactive for $days_ago days)"
            echo "    Last activity: $activity_date ($activity_type)"
            echo "    Maintenance is running but repository appears unused"
            echo "    Command: cd '$repo_dir' && git maintenance stop"

            # Store for disable summary (format: days_ago|activity_date|org_repo_path|full_path|reason)
            org_repo_path=$(get_org_repo_path "$repo_dir" "$SCAN_DIR")
            echo "$days_ago|$activity_date|$org_repo_path|$repo_dir|inactive" >>"$TEMP_DISABLE_SUMMARY"
        else
            echo "  ⏰ RECOMMENDATION: Skip maintenance (inactive for $days_ago days)"
            echo "    Last activity: $activity_date ($activity_type)"
            echo "    Consider enabling maintenance only if you plan to work on this repository again"
        fi
    else
        # Repository is active, check if maintenance should be enabled/disabled
        if [ "$recommend_maintenance" = true ]; then
            if [ "$maintenance_enabled" = true ]; then
                echo "  ✅ RECOMMENDATION: Keep maintenance enabled"
                echo "    Reasons:"
                for reason in "${reasons[@]}"; do
                    echo "      - $reason"
                done
                echo "    Last activity: $activity_date ($days_ago days ago)"
            else
                echo "  🔧 RECOMMENDATION: Enable maintenance"
                echo "    Reasons:"
                for reason in "${reasons[@]}"; do
                    echo "      - $reason"
                done
                echo "    Last activity: $activity_date ($days_ago days ago)"
                echo "    Command: cd '$repo_dir' && git maintenance start"

                # Store for summary (format: commits|branches|size_mb|days_ago|activity_date|org_repo_path|full_path)
                org_repo_path=$(get_org_repo_path "$repo_dir" "$SCAN_DIR")
                echo "$commit_count|$branch_count|$total_size_mb|$days_ago|$activity_date|$org_repo_path|$repo_dir" >>"$TEMP_SUMMARY"
            fi
        else
            # Repository doesn't meet maintenance criteria
            if [ "$maintenance_enabled" = true ]; then
                echo "  🔄 RECOMMENDATION: Consider disabling maintenance"
                echo "    Repository doesn't meet size/complexity thresholds for maintenance"
                echo "    Last activity: $activity_date ($days_ago days ago)"
                echo "    Command: cd '$repo_dir' && git maintenance stop"

                # Store for disable summary (format: days_ago|activity_date|org_repo_path|full_path|reason)
                org_repo_path=$(get_org_repo_path "$repo_dir" "$SCAN_DIR")
                echo "$days_ago|$activity_date|$org_repo_path|$repo_dir|small" >>"$TEMP_DISABLE_SUMMARY"
            else
                echo "  ✨ RECOMMENDATION: Maintenance not needed (small/clean repository)"
                echo "    Last activity: $activity_date ($days_ago days ago)"
            fi
        fi
    fi

    echo
done

# Generate summary
echo "========================================"
echo "SUMMARY: Repositories Recommended for Maintenance"
echo "========================================"
echo

if [ ! -s "$TEMP_SUMMARY" ]; then
    echo "No repositories require maintenance based on current thresholds."
    echo "(Repositories inactive for >$ACTIVITY_THRESHOLD_DAYS days are automatically excluded)"
else
    repo_count=$(wc -l <"$TEMP_SUMMARY")
    echo "Found $repo_count repositories that would benefit from Git maintenance:"
    echo "(Only showing repositories active within the last $ACTIVITY_THRESHOLD_DAYS days)"
    echo

    # Sort by commit count (descending) and display
    counter=1
    sort -t'|' -k1,1nr "$TEMP_SUMMARY" | while IFS='|' read -r commits branches size_mb days_ago activity_date org_repo_path full_path; do
        printf "%2d. %-40s - %s commits, %s branches" "$counter" "$org_repo_path" "$commits" "$branches"
        if [ "$size_mb" -gt 0 ]; then
            printf " (%sMB)" "$size_mb"
        fi
        printf " [%s days ago]" "$days_ago"
        echo
        counter=$((counter + 1))
    done

    echo
    echo "Quick enable commands (sorted by commit count):"
    echo
    sort -t'|' -k1,1nr "$TEMP_SUMMARY" | while IFS='|' read -r commits branches size_mb days_ago activity_date org_repo_path full_path; do
        echo "cd '$full_path' && git maintenance start"
    done
fi

echo
echo "========================================"
echo "SUMMARY: Repositories to Disable Maintenance"
echo "========================================"
echo

if [ ! -s "$TEMP_DISABLE_SUMMARY" ]; then
    echo "No repositories currently have unnecessary maintenance enabled."
else
    disable_count=$(wc -l <"$TEMP_DISABLE_SUMMARY")
    echo "Found $disable_count repositories where maintenance should be disabled:"
    echo

    # Sort by days ago (descending - most inactive first)
    counter=1
    sort -t'|' -k1,1nr "$TEMP_DISABLE_SUMMARY" | while IFS='|' read -r days_ago activity_date org_repo_path full_path reason; do
        if [ "$reason" = "inactive" ]; then
            printf "%2d. %-40s - inactive for %s days [last: %s]" "$counter" "$org_repo_path" "$days_ago" "$activity_date"
        else
            printf "%2d. %-40s - doesn't meet criteria [last: %s]" "$counter" "$org_repo_path" "$activity_date"
        fi
        echo
        counter=$((counter + 1))
    done

    echo
    echo "Quick disable commands (sorted by inactivity):"
    echo
    sort -t'|' -k1,1nr "$TEMP_DISABLE_SUMMARY" | while IFS='|' read -r days_ago activity_date org_repo_path full_path reason; do
        echo "cd '$full_path' && git maintenance stop"
    done
fi

echo
echo "Analysis complete!"
echo
echo "To enable maintenance on recommended repositories:"
echo "1. Navigate to the repository directory"
echo "2. Run: git maintenance start"
echo
echo "To check maintenance status: git maintenance run --dry-run"
