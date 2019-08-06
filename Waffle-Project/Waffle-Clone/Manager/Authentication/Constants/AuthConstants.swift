//
//  AuthenticationConstants.swift
//  Waffle-Clone
//
//  Created by Lubo on 1.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

struct AuthenticationConstants {
    // App specific client ID
    static let clientId = "ea4bd88e013f85f15b8d"
    // App specific client Secret
    static let clientSecret = "ea2be42b66eaba386af229d08fc98c83bc3c7639"
    // App specific callback scheme and host
    static let callbackScheme = "waffleclone"
    static let callbackHost = "gitlogin"
    // App specific redirect url
    static let redirectUrl = "\(AuthenticationConstants.callbackScheme)://\(AuthenticationConstants.callbackHost)"
}


