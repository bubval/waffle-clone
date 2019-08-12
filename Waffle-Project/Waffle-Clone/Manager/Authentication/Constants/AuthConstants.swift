//
//  AuthenticationConstants.swift
//  Waffle-Clone
//
//  Created by Lubo on 1.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

struct AuthenticationConstants {
    
    /// The client ID received from GitHub when you registered an app.
    static let clientId = "ea4bd88e013f85f15b8d"
    /// The client secret received from GitHub for the registered App.
    static let clientSecret = "ea2be42b66eaba386af229d08fc98c83bc3c7639"
    // App specific callback scheme and host
    static let callbackScheme = "waffleclone"
    static let callbackHost = "gitlogin"
    /// The URL in your application where users will be sent after authorization.
    static let redirectUrl = "\(AuthenticationConstants.callbackScheme)://\(AuthenticationConstants.callbackHost)"
    /// Key used for keychain containing access token
    static let accessTokenKey = "accessToken"
    static let userNameKey = "userName"
}


