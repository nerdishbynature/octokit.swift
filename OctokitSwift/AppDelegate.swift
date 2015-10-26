//
//  AppDelegate.swift
//  OctokitSwift
//
//  Created by Piet Brauer on 12/01/15.
//  Copyright (c) 2015 nerdish by nature. All rights reserved.
//

import UIKit
import OctoKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let config = OAuthConfiguration(token: "<your_secret>", secret: "<your_token>", scopes: ["repo", "read:org"])

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // config.authenticate()
        return true
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        config.handleOpenURL(url) { config in
            self.loadCurrentUser(config)
        }
        return false
    }

    func loadCurrentUser(config: TokenConfiguration) {
        Octokit(config).me { response in
            switch response {
            case .Success(let user):
                print(user.login)
            case .Failure(let error):
                print(error)
            }
        }
    }

}

