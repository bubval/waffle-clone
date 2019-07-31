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
        manager.get(owner: "Bubval", repo: "waffle-clone"){ (response, error) in
            if let response = response {
                print(response)
            } else {
                print(error ?? "error")
            }
        }
    }

    // Just written for the purposes of testing
    public class testingRepositoryManager: GithubManager {
        public func get(owner: String, repo: String, completion: @escaping(RepositoryResponse?, Error?) -> Void) {
            let path = "/repos/\(owner)/\(repo)"
            self.get(path: path, completion: completion)
        }
    }
}

