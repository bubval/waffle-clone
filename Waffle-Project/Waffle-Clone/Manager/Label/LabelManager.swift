//
//  LabelManager.swift
//  Waffle-Clone
//
//  Created by Lubo on 8.08.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import Foundation

class LabelManager: GithubManager {
   
    func get(owner: String, repository: String, completion: @escaping([LabelResponse]?, Error?) -> Void) {
        let path = "/repos/\(owner)/\(repository)/labels"
        self.get(path: path, completion: completion)
    }
    
    func get(name: String, owner: String, repository: String, completion: @escaping(LabelResponse?, Error?) -> Void) {
        let path = "/repos/\(owner)/\(repository)/labels/\(name)"
        self.get(path: path, completion: completion)
    }
    
    func post(owner: String, repository: String, label: LabelResponse, completion: @escaping(LabelResponse?, Error?) -> Void) {
        let path = "/repos/\(owner)/\(repository)/labels"
        self.post(path: path, body: try? JSONEncoder().encode(label), completion: completion)
    }
    
    func patch(owner: String, repository: String, label: LabelResponse, completion: @escaping(LabelResponse?, Error?) -> Void) {
        let path = "/repos/\(owner)/\(repository)/labels"
        self.patch(path: path, body: try? JSONEncoder().encode(label), completion: completion)
    }
}
