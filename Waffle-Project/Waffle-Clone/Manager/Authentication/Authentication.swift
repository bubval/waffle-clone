//
//  Authentication.swift
//  Waffle-Clone
//
//  Created by Lubo on 31.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

enum AuthenticationType {
    case none
    case headers
    case parameters
}

class Authentication {
    var type: AuthenticationType {
        return .none
    }
    var key: String {
        return ""
    }
    var value: String {
        return ""
    }
    
    init() {
        
    }
    
    func headers() -> [String : String] {
        return [key : value]
    }
}

class BasicAuthentication: Authentication {
    override var type: AuthenticationType {
        return .headers
    }
    override var key: String {
        return "Authentication"
    }
    override var value: String {
        let authorization = "\(self.username):\(self.password)"
        return "Basic \(authorization.toBase64() ?? "")"
    }
    private let username: String
    private let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    override func headers() -> [String : String] {
        return [key : value]
    }
}

class AccessTokenAuthentication: Authentication {
    override var type: AuthenticationType {
        return .parameters
    }
    override var key: String {
        return "access_token"
    }
    override var value: String {
        return "\(self.accessToken)"
    }
    private var accessToken: String

    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    override func headers() -> [String : String] {
        return [self.key: "\(self.accessToken)"]
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
