//
//  Authentication.swift
//  Waffle-Clone
//
//  Created by Lubo on 31.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation


struct Authentication {
    private var accessToken: String
    private let key = "access_token"
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func getKey() -> String {
        return key
    }
    
    func getValue() -> String {
        return accessToken
    }
    
    func getKeyValuePair() -> [String : String] {
        return [key : accessToken]
    }
}

