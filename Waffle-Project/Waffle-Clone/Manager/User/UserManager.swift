//
//  UserManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 11.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation
class UserManager: GithubManager {
   
    func getBasic(completion: @escaping(BasicUserResponse?, Error?) -> Void) {
        let path = "/user"
        self.get(path: path, completion: completion)
    }
    
    func getFull(completion: @escaping(FullUserResponse?, Error?) -> Void) {
        let path = "/user"
        self.get(path: path, completion: completion)
    }
}
