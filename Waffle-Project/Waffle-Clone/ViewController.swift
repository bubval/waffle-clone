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
            self.githubGet(path: path, completion: completion)
        }
    }

    // MARK: - Model
    public struct RepositoryResponse: Codable {
        let id: Int
        let fullName: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case fullName = "full_name"
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(Int.self, forKey: .id)
            fullName = try values.decode(String.self, forKey: .fullName)
        }
    }
}

