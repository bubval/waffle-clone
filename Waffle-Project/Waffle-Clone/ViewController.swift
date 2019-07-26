//
//  ViewController.swift
//  Waffle-Clone
//
//  Created by Lubo on 18.07.19.
//  Copyright © 2019 Tumba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let manager = test()

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
    public class test: RestManager {
        
        public func get(owner: String, repo: String, completion: @escaping(RepositoryResponse?, Error?) -> Void) {
            let decoder = JSONDecoder()
            self.get(url: "https://api.github.com/repos/\(owner)/\(repo)", parameters: nil, headers: nil) { (data, response, error) in
                if let data = data,
                    let httpResponse = response as? HTTPURLResponse {
                    do {
                        print(httpResponse.statusCode)
                        let model = try decoder.decode(RepositoryResponse.self, from: data)
                        completion(model, error)
                    } catch {
                        print(httpResponse.statusCode)
                        completion(nil, networkError.status(code: httpResponse.statusCode))
                    }
                } else {
                    if let error = error {
                        completion(nil, customError.localizedDescription(error: error))
                    } else {
                        completion(nil, networkError.unableToBuildRequest)
                    }
                }
            }
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

