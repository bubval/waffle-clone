//
//  LoginManager.swift
//  Waffle-Clone
//
//  Created by Lubomir Valkov on 2.10.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation
import UIKit

class LoginManager: GithubManager {
    let authenticationManager = AuthenticationManager()
    
    /// Performs GET to an authenticated user's repositories. Checks for successful HTTP response status.
    ///
    /// - Parameter completion: Returns true if HTTP respose status is 200. Otherwise, returns false and a String of text describing the error.
    func hasValidToken(completion: @escaping (Bool) -> ()) {
        if let accessToken = AuthenticationManager.accessToken {
            let userManager = UserManager()
            let params = ["access_token" : accessToken]
            
            userManager.get(parameters: params, headers: nil) { (response, error) in
                guard error == nil else {
                    return completion(false)
                }
                
                if let response = response {
                    AuthenticationManager.username = response.login
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            completion(false)
        }
    }
    
    func loginUser(completion: @escaping (Bool) -> ()) {
        if let authorizationUrl = self.buildLoginURL(with: Scopes.allCases) {
            UIApplication.shared.open(authorizationUrl) { (success) in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    /// Builds github login url
    ///
    /// - Parameters:
    ///   - scopes: Scopes let you specify exactly what type of access you need. Scopes limit access for OAuth tokens. The scope attribute lists scopes attached to the token that were granted by the user.
    ///   - allowSignup: Specifies if the user should be allowed to sign up
    /// - Returns: URL with scopes, redirect url, client id, and signup
    func buildLoginURL(with scopes : [Scopes], allowSignup: Bool = false) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "github.com"
        urlComponents.path = "/login/oauth/authorize"
        let scopeStrings = scopes.map { $0.rawValue }
        let scopesQueryItem = URLQueryItem(name: "scope", value: scopeStrings.joined(separator: " "))
        let redirectURIQueryItem = URLQueryItem(name: "redirect_uri", value: "\(AuthenticationConstants.redirectUrl)")
        let allowSignupQueryItem = URLQueryItem(name: "allow_signup", value: "\(allowSignup ? "true" : "false")")
        let clientIDQueryItem = URLQueryItem(name: "client_id", value: "\(AuthenticationConstants.clientId)")
        urlComponents.queryItems = [scopesQueryItem, redirectURIQueryItem, allowSignupQueryItem, clientIDQueryItem]
        return urlComponents.url
    }
}
