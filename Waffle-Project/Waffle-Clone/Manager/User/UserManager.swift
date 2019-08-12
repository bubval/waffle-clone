//
//  UserManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation
class UserManager: GithubManager {
   
    func getBasic(parameters: [String : String]? = nil, headers: [String : String]? = nil, completion: @escaping(BasicUserResponse?, Error?) -> Void) {
        let path = "/user"
        self.get(path: path, parameters: parameters, headers: headers, completion: completion)
    }
    
    func getFull(parameters: [String : String]? = nil, headers: [String : String]? = nil, completion: @escaping(FullUserResponse?, Error?) -> Void) {
        let path = "/user"
        self.get(path: path, parameters: parameters, headers: headers, completion: completion)
    }
}
