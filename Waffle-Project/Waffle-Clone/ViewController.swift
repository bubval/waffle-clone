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
        let result = addAuthenticationIfNeeded(["1":"2"], parameters: ["3":"4"])
        print(result)
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
    
    
    var authentication: BasicAuthentication? = .init(username: "Bubval", password: "Valkov97")

    
    func addAuthenticationIfNeeded(_ headers: [String : String]?, parameters: [String : String]?) -> (headers: [String : String]?, parameters: [String : String]?) {
        var newHeaders = headers
        var newParameters = parameters
        if let authentication = self.authentication {
            if authentication.type == .headers {
                if var newHeaders = newHeaders {
                    newHeaders[authentication.key] = authentication.value
                    return (newHeaders, newParameters)
                } else {
                    newHeaders = [String : String]()
                    newHeaders![authentication.key] = authentication.value
                    return (newHeaders, newParameters)
                }
            } else if authentication.type == .parameters {
                if var newParameters = newParameters {
                    newParameters[authentication.key] = authentication.value
                    return (newHeaders, newParameters)
                } else {
                    newParameters = [String : String]()
                    newParameters![authentication.key] = authentication.value
                    return (newHeaders, newParameters)
                }
            }
        }
        return (newHeaders, newParameters)
    }
}

