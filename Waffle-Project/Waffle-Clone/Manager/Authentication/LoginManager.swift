//
//  AuthManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 1.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation
import Foundation

class LoginManager: GithubManager {
    enum Parameters: String {
        case clientID = "client_id"
        case clientSecret = "client_secret"
        case code
        case redirectURL = "redirect_uri"
    }
    
    
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
                    completion(model, error)
                } catch {
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    func isValidToken(completion: @escaping (Bool) -> Void) {
        if let accessToken = LoginManager.AccessToken {
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

extension LoginManager {
    
    private static var keychain = Keychain(keychainQueryable: Queryable(service: "accessToken"))
    
    class var AccessToken: String? {
        get {
            do {
                let token = try keychain.getValue(for: "accessToken")
                return token
            } catch (let e) {
                print("Saving generic password failed with \(e.localizedDescription).")
            }
            return nil
        }
        set {
            do {
                if let newValue = newValue {
                    try self.keychain.setValue(newValue, for: "accessToken")
                }
            } catch (let e) {
                print("Saving generic password failed with \(e.localizedDescription).")
            }
        }
    }
}
