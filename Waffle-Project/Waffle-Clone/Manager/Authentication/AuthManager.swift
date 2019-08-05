//
//  AuthManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 1.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation


class AuthenticationManager: GithubManager {
    enum Parameters: String {
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case code
        case redirectURL = "redirect_uri"
    }
    
    
    /// Performs http GET under AccessTokenResponse model for purposes of authentication
    ///
    /// - Parameters:
    ///   - clientID: App specific client id
    ///   - clientSecret: App specific client secret
    ///   - code: Identifies user after login
    ///   - redirectURL: App specific redirect url
    ///   - completion: Returns AccessTokenResponse containing access token, scope and user type. Othewise, returns error.
    func getAccessToken(clientID: String, clientSecret: String, code: String, redirectURL: String, completion: @escaping(AccessTokenResponse?, Error?) -> Void) {
        let url = "https://github.com/login/oauth/access_token"
        
        var parameters = [String : String]()
        parameters[Parameters.clientID.rawValue] = clientID
        parameters[Parameters.clientSecret.rawValue] = clientSecret
        parameters[Parameters.code.rawValue] = code
        parameters[Parameters.redirectURL.rawValue] = redirectURL
        
        var headers = [String : String]()
        headers["Accept"] = "application/json"
        
        self.get(url: url, parameters: parameters, headers: headers) { (data, _, error) in
            if let data = data {
                do {
                    let model = try JSONDecoder().decode(AccessTokenResponse.self, from: data)
                    completion(model, nil)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    /// Performs an http GET of the authenticated GitHub user.
    ///
    /// - Parameter completion: Returns true if status code = 200, otherwise returns false
    func isValidToken(completion: @escaping (Bool) -> Void) {
        if let accessToken = AuthenticationManager.AccessToken {
            let url = "https://api.github.com/user/repos"
            let params = ["access_token" : accessToken]
            
            self.get(url: url, parameters: params, headers: nil) { (_, httpResponse, _) in
                if let httpResponse = httpResponse as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
}

extension AuthenticationManager {
    
    private static var keychain = Keychain(keychainQueryable: Queryable(service: "accessToken"))
    
    class var AccessToken: String? {
        get {
            do {
                let token = try keychain.getValue(for: "accessToken")
                return token
            } catch {
                print(KeychainError.gettingError)
            }
            return nil
        }
        set {
            do {
                if let newValue = newValue {
                    try self.keychain.setValue(newValue, for: "accessToken")
                }
            } catch {
                print(KeychainError.savingError)
            }
        }
    }
}

extension AuthenticationManager {
    
    /// Builds github login url
    ///
    /// - Parameters:
    ///   - scopes: Specifies the type of access
    ///   - allowSignup: Specifies if the user should be allowed to sign up
    /// - Returns: URL with scopes, redirect url, client id which allows signup if specified
    func buildLoginURL(with scopes : [Scopes], allowSignup: Bool) -> URL {
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
        return urlComponents.url!
    }
}
