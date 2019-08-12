//
//  AuthManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 1.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation
import UIKit


class AuthenticationManager: GithubManager {
    
    /// Performs http GET under AccessTokenResponse model for purposes of authentication
    ///
    /// - Parameters:
    ///   - code: Token identifying user identity derived from UIApplication
    ///   - completion: Returns AccessTokenResponse (access token, scope and user type) or error.
    func getAccessToken(code: String, completion: @escaping(AccessTokenResponse?, Error?) -> Void) {
        let url = "https://github.com/login/oauth/access_token"
        
        var parameters = [String : String]()
        parameters["client_id"] = AuthenticationConstants.clientId
        parameters["client_secret"] = AuthenticationConstants.clientSecret
        parameters["code"] = code
        parameters["redirect_url"] = AuthenticationConstants.redirectUrl
        
        var headers = [String : String]()
        headers["Accept"] = "application/json"
        
        self.get(url: url, parameters: parameters, headers: headers) { (data, response , error) in
            guard error == nil else {
                return completion(nil, UnknownError.internalError(error: error!))
            }
            
            if let response = response as? HTTPURLResponse {
                guard response.statusCode >= 200 && response.statusCode <= 299 else {
                    return completion(nil, NetworkError.status(code: response.statusCode))
                }
            }
            
            if let data = data {
                do {
                    let model = try JSONDecoder().decode(AccessTokenResponse.self, from: data)
                    completion(model, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
    
    /// Performs GET to an authenticated user's repositories. Checks for successful HTTP response status.
    ///
    /// - Parameter completion: Returns true if HTTP respose status is 200. Otherwise, returns false and a String of text describing the error.
    func hasValidToken(completion: @escaping (Bool, String?) -> ()) {
        if let accessToken = AuthenticationManager.accessToken {
            print(AuthenticationManager.accessToken)

            let userManager = UserManager()
            let params = ["access_token" : accessToken]

            userManager.getBasic(parameters: params, headers: nil) { (response, error) in
                guard error == nil else {
                    return completion(false, error!.localizedDescription)
                }
                
                if let response = response {
                    AuthenticationManager.username = response.login
                    completion(true, nil)
                } else {
                    completion(false, "Github response failed.")
                }
            }
        } else {
            completion(false, "Automatic sign in could not be completed")
        }
    }
}

extension AuthenticationManager {
    private static var userNameKeychain = Keychain(keychainQueryable: Queryable(service: AuthenticationConstants.userNameKey))
    
    class var username: String? {
        get {
            do {
                let username = try userNameKeychain.getValue(for: AuthenticationConstants.userNameKey)
                return username
            } catch {
                print(KeychainError.gettingError.description)
            }
            return nil
        }
        set {
            do {
                if let newValue = newValue {
                    try self.userNameKeychain.setValue(newValue, for: AuthenticationConstants.userNameKey)
                }
            } catch {
                print(KeychainError.savingError.description)
            }
        }
    }
}

extension AuthenticationManager {
    
    private static var accessTokenKeychain = Keychain(keychainQueryable: Queryable(service: AuthenticationConstants.accessTokenKey))
    
    /// Provides access to keychain containing the access token.
    class var accessToken: String? {
        get {
            do {
                let token = try accessTokenKeychain.getValue(for: AuthenticationConstants.accessTokenKey)
                return token
            } catch {
                print(KeychainError.gettingError.description)
            }
            return nil
        }
        set {
            do {
                if let newValue = newValue {
                    try self.accessTokenKeychain.setValue(newValue, for: AuthenticationConstants.accessTokenKey)
                }
            } catch {
                print(KeychainError.savingError.description)
            }
        }
    }
}

extension AuthenticationManager {
    
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
