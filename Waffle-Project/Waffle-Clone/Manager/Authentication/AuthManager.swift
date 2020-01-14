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
    static var accessToken: String? {
        get {
            do {
                let token = try accessTokenKeychain.getValue(for: AuthenticationConstants.accessTokenKey)
                return token
            } catch {
                print("KeychainError::", KeychainError.gettingError.description)
            }
            return nil
        }
        set {
            do {
                if let newValue = newValue {
                    try self.accessTokenKeychain.setValue(newValue, for: AuthenticationConstants.accessTokenKey)
                }
            } catch {
                print("KeychainError::", KeychainError.savingError.description)
            }
        }
    }
}

