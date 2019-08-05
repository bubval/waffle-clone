//
//  AuthenticationConstants.swift
//  Waffle-Clone
//
//  Created by Lubo on 1.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

struct AuthenticationConstants {
    static let clientId = "ea4bd88e013f85f15b8d"
    static let clientSecret = "ea2be42b66eaba386af229d08fc98c83bc3c7639"
    static let callbackScheme = "waffleclone"
    static let callbackHost = "gitlogin"
    static let redirectUrl = "\(AuthenticationConstants.callbackScheme)://\(AuthenticationConstants.callbackHost)"
}


