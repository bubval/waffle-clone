//
//  ViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 18.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let manager = testingRepositoryManager()

    override func viewDidLoad() {
        super.viewDidLoad()
//        let result = addAuthenticationIfNeeded(["1":"2"], parameters: ["3":"4"])
//        print(result)
    
        manager.repositories { (response, error) in
            if let response = response {
                print(response)
            } else {
                print(error ?? "error")
            }
        }
    }

    // Just written for the purposes of testing
    public class testingRepositoryManager: GithubManager {
        let auth = BasicAuthentication(username: "Bubval", password: "Valkov97")
        
        public func get(owner: String, repo: String, completion: @escaping(RepositoryResponse?, Error?) -> Void) {
            let path = "/repos/\(owner)/\(repo)"
            self.get(path: path, completion: completion)
        }
        
        public func repositories(completion: @escaping([RepositoryResponse]?, Error?) -> Void) {
            let path = "/user/repos"
            super.authentication = auth
           
            self.get(path: path, completion: completion)
        }
    }
    
    
}

