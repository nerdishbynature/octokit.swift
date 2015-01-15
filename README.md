# Octokit.swift

## Authentication

Octokit supports both, Github and Github Enterprise.
Authentication is handled using Configurations.

There are too types of Configurations, `TokenConfiguration` and `OAuthConfiguration`.

### TokenConfiguration

`TokenConfiguration` is used if you are using Access Token based Authentication (e.g. the user
offered you an access token he generated on the website) or if you got an Access Token through
the OAuth Flow

You can initialize a new config for `github.com` as follows:

```swift
let config = TokenConfiguration(token: "12345")
```

or for Github Enterprise

```swift
let config = TokenConfiguration("https://github.example.com/api/v3/", token: "12345")
```

After you got your token you can use it with `Octokit`

```swift
Octokit(config).me { response in
  switch response {
  case .Success(let user):
    println(user.login)
  case .Failure(let error):
    println(error)
  }
}
```

### OAuthConfiguration

`OAuthConfiguration` is meant to be used, if you don't have an access token already and the
user has to login to your application. This also handles the OAuth flow.

You can authenticate an user for `github.com` as follows:

```swift
let config = OAuthConfiguration(token: "<Your Client ID>", secret: "<Your Client secret>", scopes: ["repo", "read:org"])
config.authenticate()

```

or for Github Enterprise

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
  Octokit(config).me { response in
    switch response {
    case .Success(let user):
      println(user.login)
    case .Failure(let error):
      println(error)
    }
  }
}
```

Please note that you will be given a `TokenConfiguration` back from the OAuth flow.
You have to store the `accessToken` yourself. If you want to make further requests it is not
necessary to do the OAuth Flow again. You can just use a `TokenConfiguration`.

```swift
let token = // get your token from your keychain, user defaults (not recommended) etc.
let config = TokenConfiguration(token)
Octokit(config).user("octocat") { user in
  println(user.login) // octocat
}
```
