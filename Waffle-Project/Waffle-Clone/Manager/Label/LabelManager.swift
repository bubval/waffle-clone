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
    
//    let defaultLabels = [LabelResponse(name: "Product Backlog", description: nil, color: "ff5733"),
//                         LabelResponse(name: "Sprint Backlog", description: nil, color: "ff5732"),
//                         LabelResponse(name: "In Progress", description: nil, color: "ff5731"),
//                         LabelResponse(name: "Done", description: nil, color: "ff5730"),
//                         LabelResponse(name: "Tested", description: nil, color: "ff5729"),
//                         LabelResponse(name: "Completed", description: nil, color: "ff5728")]
}
extension LabelManager {
    
    class var defaultLabels: [LabelResponse] {
        get {
            do {
                return [LabelResponse(name: "Product Backlog", description: nil, color: "ff5733"),
                        LabelResponse(name: "Sprint Backlog", description: nil, color: "ff5732"),
                        LabelResponse(name: "In Progress", description: nil, color: "ff5731"),
                        LabelResponse(name: "Done", description: nil, color: "ff5730"),
                        LabelResponse(name: "Tested", description: nil, color: "ff5729"),
                        LabelResponse(name: "Completed", description: nil, color: "ff5728")]
            }
        }
    }
}
