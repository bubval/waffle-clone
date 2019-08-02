//
//  Authentication.swift
//  Waffle-Clone
//
//  Created by Lubo on 31.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

enum AuthenticationType {
    case missing
    case basic
    case basicToken
    case accessToken
}

struct Authentication {
    private var username: String?
    private var password: String?
    private var token: String?
    var type: AuthenticationType
    
    init?(accessToken: String) {
        self.type = .accessToken
        self.token = accessToken
    }
    
    init?(basicToken: String) {
        self.type = .basicToken
        self.token = basicToken
    }
    
    init?(username: String, password: String) {
        self.type = .basic
        self.username = username
        self.password = password
    }
    
    init() {
        self.type = .missing
    }
    
    private var key: String {
        switch type {
        case .missing:
            return ""
        case .basic:
            return "Authorization"
        case .basicToken:
            return "Authorization"
        case .accessToken:
            return "access_token"
        }
    }
    
    private var value: String {
        switch type {
        case .missing:
            return ""
        case .basic:
            if let username = self.username,
                let password = self.password {
                let authorization = "\(username):\(password)"
                if let token = authorization.toBase64() {
                    return "Basic \(token)"
                }
            }
        case .basicToken:
            if let token = self.token {
                return "Basic \(token)"
            }
        case .accessToken:
            if let token = self.token {
                return token
            }
        }
        return ""
    }
    
    func getKey() -> String {
        return key
    }
    
    func getValue() -> String {
        return value
    }
    
    func getKeyValuePair() -> [String : String] {
        return [key : value]
    }
}

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}
