# OctoKit CLI

A command-line tool for GitHub built on [octokit.swift](https://github.com/nerdishbynature/octokit.swift).

## Requirements

- macOS 12+
- Swift 5.7+

## Build

```bash
cd OctoKitCLI
swift build
```

The binary lands at `.build/debug/OctoKitCLI`. For a release build:

```bash
swift build -c release
# binary at .build/release/OctoKitCLI
```

## Run

```bash
swift run OctoKitCLI <command> [subcommand] [arguments]
```

Or run the built binary directly:

```bash
.build/debug/OctoKitCLI <command> [subcommand] [arguments]
```

## Authentication

Commands that access your own data (issues, stars, gists, followers, notifications) require a GitHub token. Set it via the `GITHUB_TOKEN` environment variable:

```bash
export GITHUB_TOKEN=ghp_yourtoken
```

Or prefix individual commands:

```bash
GITHUB_TOKEN=ghp_yourtoken .build/debug/OctoKitCLI issue get-my-list
```

Public read operations (get a repo, list releases, etc.) work without a token.

## Output

All commands print pretty-printed JSON to stdout by default. To write to a file instead, pass a file path as the last argument:

```bash
.build/debug/OctoKitCLI repository get nerdishbynature octokit.swift /tmp/repo.json
```

Add `--verbose` to any command to print the HTTP method and URL used.

## Commands

### `issue`

```bash
# Get a single issue
octokit-cli issue get <owner> <repo> <number>

# List issues for a repository
octokit-cli issue get-list <owner> <repo>

# List issues assigned to you (requires GITHUB_TOKEN)
octokit-cli issue get-my-list

# Get comments on an issue
octokit-cli issue get-comments <owner> <repo> <number>
```

### `repository`

```bash
# Get a single repository
octokit-cli repository get <owner> <name>

# List repositories for a user or org
octokit-cli repository get-list <owner>

# Get topics for a repository
octokit-cli repository get-topics <owner> <name>

# Get contents at a path (omit path for root)
octokit-cli repository get-content <owner> <name> [path] [--ref <branch-or-tag>]
```

### `follower`

```bash
# List followers of a user
octokit-cli follower get-list <name>

# List your followers (requires GITHUB_TOKEN)
octokit-cli follower get-my-list

# List who you follow (requires GITHUB_TOKEN)
octokit-cli follower get-my-following

# List who a user follows
octokit-cli follower get-following <name>
```

### `label`

```bash
# Get a single label
octokit-cli label get <owner> <repo> <name>

# List labels for a repository
octokit-cli label get-list <owner> <repo>
```

### `milestone`

```bash
# Get a single milestone
octokit-cli milestone get <owner> <repo> <number>

# List milestones for a repository
octokit-cli milestone get-list <owner> <repo>
```

### `pull-request`

```bash
# Get a single pull request
octokit-cli pull-request get <owner> <repo> <number>

# List pull requests for a repository
octokit-cli pull-request get-list <owner> <repo>
```

### `release`

```bash
# List releases for a repository
octokit-cli release get-list <owner> <repo>

# Get the latest release
octokit-cli release get-latest <owner> <repo>
```

### `review`

```bash
# List reviews for a pull request
octokit-cli review get-list <owner> <repo> <number>
```

### `search`

```bash
# Search code (requires GITHUB_TOKEN)
octokit-cli search code <query>
```

### `star`

```bash
# List starred repositories for a user
octokit-cli star get-list <name>

# List your starred repositories (requires GITHUB_TOKEN)
octokit-cli star get-my-list
```

### `status`

```bash
# List commit statuses for a ref
octokit-cli status get-list <owner> <repo> <ref>
```

### `user`

```bash
# Get a user by login
octokit-cli user get <name>
```

### `gist`

```bash
# Get a single gist by ID
octokit-cli gist get <id>

# List gists for a user
octokit-cli gist get-list <owner>

# List your gists (requires GITHUB_TOKEN)
octokit-cli gist get-my-list

# List your starred gists (requires GITHUB_TOKEN)
octokit-cli gist get-my-starred
```

### `notification`

```bash
# List your notifications (requires GITHUB_TOKEN)
octokit-cli notification get-list

# Get a single notification thread (requires GITHUB_TOKEN)
octokit-cli notification get-thread <thread-id>
```

## Global flags

| Flag | Description |
|---|---|
| `--verbose` | Print the HTTP method and URL |
| `--help` | Show help for any command |

## Examples

```bash
# Fetch the latest release of octokit.swift
.build/debug/OctoKitCLI release get-latest nerdishbynature octokit.swift

# Save repo topics to a file
.build/debug/OctoKitCLI repository get-topics nerdishbynature octokit.swift /tmp/topics.json

# Show verbose output for a user lookup
.build/debug/OctoKitCLI user get nerdishbynature --verbose

# List your open issues
GITHUB_TOKEN=ghp_xxx .build/debug/OctoKitCLI issue get-my-list

# Search code (requires auth)
GITHUB_TOKEN=ghp_xxx .build/debug/OctoKitCLI search code "func milestone repo:nerdishbynature/octokit.swift"
```
