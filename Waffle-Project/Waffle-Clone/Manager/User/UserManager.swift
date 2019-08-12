//
//  UserManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation
class UserManager: GithubManager {
    
    func get(parameters: [String : String]? = nil, headers: [String : String]? = nil, completion: @escaping(UserResponse?, Error?) -> Void) {
        let path = "/user"
        self.get(path: path, parameters: parameters, headers: headers, completion: completion)
    }
}
