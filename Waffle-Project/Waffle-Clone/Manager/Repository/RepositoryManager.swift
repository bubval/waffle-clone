//
//  RepositoryManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 7.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

class RepositoryManager: GithubManager {
    
    func repositories(completion: @escaping([RepositoryResponse]?, Error?) -> Void) {
        let path = "/user/repos"
        self.get(path: path, completion: completion)
    }
}
