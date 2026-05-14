#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
CLI_DIR="$REPO_ROOT/OctoKitCLI"
FIXTURES_DIR="$REPO_ROOT/Tests/OctoKitTests/Fixtures"
OUTPUT_DIR="/tmp/octokit-live"

echo "Building OctoKitCLI..."
(cd "$CLI_DIR" && swift build -c release 2>&1) || {
    echo "Build failed."
    exit 1
}
CLI="$CLI_DIR/.build/release/OctoKitCLI"

mkdir -p "$OUTPUT_DIR"

FAILED=()

run_cmd() {
    local name="$1"; shift
    echo "  → $name"
    "$CLI" "$@" "$OUTPUT_DIR/$name" || FAILED+=("$name")
}

echo ""
echo "Fetching live API responses..."

# User (no list endpoint in CLI — users.json must be maintained manually)
run_cmd "user_mietzmithut.json"     user       get       nerdishbynature

# Repository
run_cmd "repo.json"                 repository get       nerdishbynature   octokit.swift
run_cmd "user_repos.json"           repository get-list  nerdishbynature
run_cmd "tags.json"                 repository get-tags  nerdishbynature   octokit.swift

# Issue
run_cmd "issue.json"                issue      get       nerdishbynature   octokit.swift   1
run_cmd "issues.json"               issue      get-list  nerdishbynature   octokit.swift

# Pull Request
run_cmd "pull_request.json"         pull-request get     nerdishbynature   octokit.swift   1
run_cmd "pull_requests.json"        pull-request get-list nerdishbynature   octokit.swift --state closed --per-page 10

# Release
run_cmd "releases.json"             release    get-list  nerdishbynature   octokit.swift

# Review (PR #202 has known reviews)
run_cmd "reviews.json"              review     get-list  nerdishbynature   octokit.swift   202

# Label
run_cmd "labels.json"               label      get-list  nerdishbynature   octokit.swift

# Status: skip — nerdishbynature/octokit.swift uses GitHub Actions (Checks API), not Commit Status API.
# statuses.json retains its existing fixture data for model decode tests.
# run_cmd "statuses.json"           status     get-list  nerdishbynature   octokit.swift   main

# Star
run_cmd "stars.json"                star       get-list  nerdishbynature

# Follower
run_cmd "followers.json"            follower   get-list  nerdishbynature

# Gist list (octocat has known public gists; nerdishbynature has 0)
run_cmd "gists.json"                gist       get-list  octocat

echo ""
echo "Sorting JSON keys..."
"$CLI" sorted-json-keys "$OUTPUT_DIR"/*.json

echo ""
if [ ${#FAILED[@]} -gt 0 ]; then
    echo "⚠  Failed commands: ${FAILED[*]}"
fi

echo "Diffing against existing fixtures..."
DIFFS=0
for f in "$OUTPUT_DIR"/*.json; do
    name=$(basename "$f")
    existing="$FIXTURES_DIR/$name"
    if [ -f "$existing" ]; then
        if ! diff -q "$existing" "$f" > /dev/null 2>&1; then
            echo ""
            echo "CHANGED: $name"
            diff -u "$existing" "$f" || true
            DIFFS=$((DIFFS + 1))
        fi
    else
        echo ""
        echo "NEW: $name"
        DIFFS=$((DIFFS + 1))
    fi
done

echo ""
if [ "$DIFFS" -eq 0 ] && [ ${#FAILED[@]} -eq 0 ]; then
    echo "All fixtures up to date."
else
    if [ "$DIFFS" -gt 0 ]; then
        echo "$DIFFS file(s) changed or new."
        echo ""
        echo "To update fixtures run:"
        echo "  cp $OUTPUT_DIR/*.json $FIXTURES_DIR/"
        echo ""
        echo "Then fix broken test assertions:"
        echo "  cd $REPO_ROOT && swift test 2>&1 | grep 'XCTAssert.*failed'"
    fi
fi
