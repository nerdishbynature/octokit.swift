# Octokit.swift

[![Build Status](https://travis-ci.org/nerdishbynature/octokit.swift.svg?branch=master)](https://travis-ci.org/nerdishbynature/octokit.swift)
[![CocoaPods](https://img.shields.io/cocoapods/v/OctoKit.swift.svg)](https://cocoapods.org/pods/OctoKit.swift)
[![codecov.io](https://codecov.io/github/nerdishbynature/octokit.swift/coverage.svg?branch=master)](https://codecov.io/github/nerdishbynature/octokit.swift?branch=master)

## Installation

- **Using [Swift Package Manager](https://swift.org/package-manager)**:

```swift
import PackageDescription

let package = Package(
  name: "MyAwesomeApp",
    dependencies: [
      .package(url: "https://github.com/nerdishbynature/octokit.swift", from: "0.11.0"),
    ]
  )
```

## Authentication

Octokit supports both, GitHub and GitHub Enterprise.
Authentication is handled using Configurations.

There are two types of Configurations, `TokenConfiguration` and `OAuthConfiguration`.

### TokenConfiguration

`TokenConfiguration` is used if you are using Access Token based Authentication (e.g. the user
offered you an access token he generated on the website) or if you got an Access Token through
the OAuth Flow

You can initialize a new config for `github.com` as follows:

```swift
let config = TokenConfiguration("YOUR_PRIVATE_GITHUB_TOKEN_HERE")
```

or for GitHub Enterprise

```swift
let config = TokenConfiguration("YOUR_PRIVATE_GITHUB_TOKEN_HERE", url: "https://github.example.com/api/v3/")
```

After you got your token you can use it with `Octokit`

```swift
Octokit(config).me() { response in
  switch response {
  case .success(let user):
    print(user.login as Any)
  case .failure(let error):
    print(error)
  }
}
```

### OAuthConfiguration

`OAuthConfiguration` is meant to be used, if you don't have an access token already and the
user has to login to your application. This also handles the OAuth flow.

You can authenticate an user for `github.com` as follows:

```swift
let config = OAuthConfiguration(token: "<Your Client ID>", secret: "<Your Client secret>", scopes: ["repo", "read:org"])
let url = config.authenticate()
```

or for GitHub Enterprise

```swift
let config = OAuthConfiguration("https://github.example.com/api/v3/", webURL: "https://github.example.com/", token: "<Your Client ID>", secret: "<Your Client secret>", scopes: ["repo", "read:org"])
```

After you got your config you can authenticate the user:

```swift
// AppDelegate.swift

config.authenticate()

func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
  config.handleOpenURL(url) { config in
    self.loadCurrentUser(config) // purely optional of course
  }
  return false
}

func loadCurrentUser(config: TokenConfiguration) {
  let user = try? await Octokit(config).me()
}
```

Please note that you will be given a `TokenConfiguration` back from the OAuth flow.
You have to store the `accessToken` yourself. If you want to make further requests it is not
necessary to do the OAuth Flow again. You can just use a `TokenConfiguration`.

```swift
let token = // get your token from your keychain, user defaults (not recommended) etc.
let config = TokenConfiguration(token)
do {
  let user = try await Octokit(config).user(name: "octocat")
  print("User login: \(user.login!)")
} catch {
  print("Error: \(error)")
}
```

## Users

### Get a single user

```swift
let username = ... // set the username
do {
  let user = try await Octokit().user(name: username)
  // do something with the user
catch {
  // handle any errors
}
```

### Get the authenticated user

```swift
do {
  let user = try await Octokit().me()
  // do something with the user
catch {
  // handle any errors
}
```

## Repositories

### Get a single repository

```swift
let (owner, name) = ("owner", "name") // replace with actual owner and name
do {
  let repository = try await Octokit().repository(owner, name)
  // do something with the repository
} catch {
  // handle any errors
}
```

### Get repositories of authenticated user

```swift
do {
  let repositories = try await Octokit().repositories()
  // do something
} catch {
  // handle any errors
}
```

## Starred Repositories

### Get starred repositories of some user

```swift
let username = "username"
do {
  let repositories = try await Octokit().stars(username)
  // do something with the repositories
} catch  {
  // handle any errors
}
```

### Get starred repositories of authenticated user

```swift
do {
  let repositories = try await Octokit().myStars()
  // do something with the repositories
} catch {
  // handle any errors
}
```

## Follower and Following

### Get followers of some user

```swift
let username = "username"
do {
  let users = try await Octokit().followers(username)
  // do something with the users
} catch {
  // handle any errors
}
```

### Get followers of authenticated user

```swift
do {
  let users = try await Octokit().myFollowers()
  // do something with the users
} catch {
  // handle any errors
}
```

### Get following of some user

```swift
let username = "username"
do {
  let users = try await Octokit().following(username)
  // do something with the users
} catch {
  // handle any errors
}
```

### Get following of authenticated user

```swift
do {
  let users = try await Octokit().myFollowing()
  // do something with the users
} catch {
  // handle any errors
}
```

## Issues

### Get issues of authenticated user

Get all issues across all the authenticated user's visible repositories including owned repositories, member repositories, and organization repositories.

```swift
do {
  let issues = try await Octokit(config).myIssues()
  // do something with the issues
} catch {
  // handle any errors
}
```

### Get a single issue

```swift
let (owner, repo, number) = ("owner", "repo", 1347) // replace with actual owner, repo name, and issue number
do {
  let issue = try await Octokit(config).issue(owner, repository: repo, number: number)
} catch {
  // handle any errors

```

### Open a new issue

```swift
do {
  let issue = try await Octokit(config).postIssue("owner", repository: "repo", title: "Found a bug", body: "I'm having a problem with this.", assignee: "octocat", labels: ["bug", "duplicate"])
  // do something with the issue
} catch {
  // handle any errors
}
```

### Edit an existing issue

```swift
do {
  let issue = try await Octokit(config).patchIssue("owner", repository: "repo", number: 1347, title: "Found a bug", body: "I'm having a problem with this.", assignee: "octocat", state: .Closed) 
  // do something with the issue
} catch {
  // handle any errors
}
```

### Comment an issue

```swift
do {
  let comment = try await Octokit().commentIssue(owner: "octocat", repository: "Hello-World", number: 1, body: "Testing a comment")
  // do something with the comment
} catch {
  // handle any errors
}
```

### Edit an existing comment

```swift
do {
  let comment = try await Octokit().patchIssueComment(owner: "octocat", repository: "Hello-World", number: 1, body: "Testing a comment")
  // do something with the comment
} catch {
  // handle any errors
}
```

## Pull requests

### Get a single pull request
```swift
do {
  let pullRequest = try await Octokit().pullRequest(owner: "octocat", repository: "Hello-World", number: 1)
  // do something with a pull request
} catch {
  // handle any errors
}
```

### List pull requests
```swift
do {
  let pullRequests = try await Octokit().pullRequests(owner: "octocat", repository: "Hello-World", base: "develop", state: Openness.Open)
  // do something with a pull request list
} catch {
  // handle any errors
}
```

## Releases

### Create a new release
```swift
do {
  let release = try await Octokit().postRelease(owner: "octocat", repository: "Hello-World", tagName: "v1.0.0", targetCommitish: "master", name: "v1.0.0 Release", body: "The changelog of this release", prerelease: false, draft: false)
  // do something with the release
} catch {
  // handle any errors
}
```
